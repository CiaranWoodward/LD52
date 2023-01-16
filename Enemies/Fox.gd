extends Node2D

export var sight_range = 450.0
export var wander_speed = 70.0
export var rotate_speed = PI/2
export var health = 20
export var torment_value = 0.3

var goto_point = Vector2.INF
var cur_direction = Vector2(0, 0)

export var mooncrane_priority = 2
export var mooncrane_hit_range = 30
var _mouse_over = false

# Fox goes: Spawn -> Relay -> Torment zone

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
	_selected_card_changed(null, null)
	$AnimationPlayer.play("Spawn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dest
	if goto_point != Vector2.INF:
		dest = goto_point
	else:
		return
	var cur_speed = wander_speed
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

func relay():
	goto_random_zone(get_tree().get_nodes_in_group("enemy_relay_zones"))

func wander():
	goto_closest_zone(get_tree().get_nodes_in_group("enemy_torment_zones"))

func damage(damage):
	if health < 0:
		return
	health -= damage
	$Hurt.pitch_scale = rand_range(0.7, 1.3)
	$Hurt.play()
	$Mask/Fill/DamageFlash.active = true
	if health <= 0:
		$AnimationPlayer.play("Die")
		$Idle.stop()

func cheer():
	return -torment_value

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Die":
		queue_free()

func is_under_mouse() -> bool:
	return _mouse_over

func target_position():
	return global_position

func _mouseentered():
	_mouse_over = true
	
func _mouseexited():
	_mouse_over = false

func _selected_card_changed(_old, new):
	$Mask/TargetGlow.active = is_mooncrane_selected()

func is_mooncrane_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.CRANE
