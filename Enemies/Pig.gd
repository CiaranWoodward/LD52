extends Node2D

export var speed = 40.0
export var rotate_speed = PI/2
export var attack_range = 30.0
export var health = 60
export var steal_amount = 0.3
export var torment_value = 0.1

var goto_point = Vector2.INF
var target : Node2D = null
var cur_direction = Vector2(0, 0)

export var mooncrane_priority = 2
export var mooncrane_hit_range = 30
var _mouse_over = false
var escaping = false
var relaying = false

# Pig goes: Spawn -> Relay -> Stall -> Escape -> Relay

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_direction = Vector2(rand_range(-10, 10), rand_range(-10, 10))
	cur_direction = cur_direction.normalized()
	self.call_deferred("relay")
	add_to_group("mooncrane_targets")
	add_to_group("enemies")
	add_to_group("cheers")
	Global.connect("change_selected_card", self, "_selected_card_changed")
	$MooncraneTarget.connect("mouse_entered", self, "_mouseentered")
	$MooncraneTarget.connect("mouse_exited", self, "_mouseexited")
	is_mooncrane_selected()
	$AnimationPlayer.play("Spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dest
	kill_target()
	if is_instance_valid(target) && !target.has_stock():
		target = null
		wander()
	if !escaping && !relaying && !is_instance_valid(target):
		find_target()
	if is_instance_valid(target):
		dest = target.get_global_position()
	elif goto_point != Vector2.INF:
		dest = goto_point
	else:
		return
	var cur_speed = speed
	var distance_covered = delta * cur_speed
	var distance_left = global_position.distance_to(dest)
	var desired_direction = global_position.direction_to(dest)
	var angle = cur_direction.angle_to(desired_direction)
	var max_rotate_speed = rotate_speed * delta
	if abs(angle) > max_rotate_speed:
		angle = sign(angle) * max_rotate_speed
	cur_direction = cur_direction.rotated(angle)
	if distance_left <= distance_covered:
		global_position = dest
		if is_instance_valid(target):
			pass
		elif escaping || relaying:
			escaping = false
			relaying = false
			relay(false)
		else:
			wander()
	else:
		global_position += cur_direction * distance_covered

func goto_random_zone(zones):
	if zones.size() == 0:
		goto_point = Vector2.INF
		return
	zones.shuffle()
	var zone = zones[0]
	goto_point = zone.get_global_point_in_zone()

func goto_closest_zone(zones):
	var best_zone = null
	var best_distance = INF
	for zone in zones:
		var dist = global_position.distance_to(zone.global_center)
		if dist < best_distance:
			best_distance = dist
			best_zone = zone
	if !is_instance_valid(best_zone):
		goto_point = Vector2.INF
		return
	goto_point = best_zone.get_global_point_in_zone()

func relay(locked=true):
	target = null
	if locked:
		relaying = true
	goto_random_zone(get_tree().get_nodes_in_group("enemy_relay_zones"))

func wander():
	goto_random_zone(get_tree().get_nodes_in_group("enemy_cat_zones"))

func escape():
	escaping = true
	target = null
	goto_closest_zone(get_tree().get_nodes_in_group("enemy_escape_zones"))

func kill_target():
	if is_instance_valid(target) && global_position.distance_to(target.global_position) < attack_range:
		if target.has_stock():
			target.steal(steal_amount)
			#TODO: add stolen sprite
		escape()

func damage(damage):
	if health < 0:
		return
	health -= damage
	$Hurt.pitch_scale = rand_range(0.8, 1.2)
	$Hurt.play()
	$Mask/Fill/DamageFlash.active = true
	if health <= 0:
		$Idle.stop()
		$AnimationPlayer.play("Die")

func cheer():
	return -torment_value

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Die":
		queue_free()

func find_target():
	var stalls = get_tree().get_nodes_in_group("stalls")
	
	var best_stall = null
	var best_distance = INF
	for stall in stalls:
		if !stall.has_stock():
			continue
		var dist = global_position.distance_to(stall.global_position)
		if dist < best_distance:
			best_distance = dist
			best_stall = stall
	if is_instance_valid(best_stall):
		target = best_stall

func is_under_mouse() -> bool:
	return _mouse_over

func target_position():
	return $MooncraneTarget.global_position

func _mouseentered():
	_mouse_over = true
	
func _mouseexited():
	_mouse_over = false

func _selected_card_changed(_old, new):
	$Mask/TargetGlow.active = is_mooncrane_selected()

func is_mooncrane_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.CRANE
