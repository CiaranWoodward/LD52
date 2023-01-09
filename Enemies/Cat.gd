extends Node2D

export var sight_range = 450.0
export var wander_speed = 100.0
export var speed = 200.0
export var rotate_speed = PI/2
export var attack_range = 30.0

var goto_point = Vector2.INF
var target : Node2D = null
var cur_direction = Vector2(0, 0)

# Cat goes: Spawn -> Relay -> Catzone -> Hunt crane -> Catzone

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	cur_direction = Vector2(rand_range(-10, 10), rand_range(-10, 10))
	cur_direction = cur_direction.normalized()
	self.call_deferred("relay")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var dest
	kill_target()
	if !is_instance_valid(target):
		find_target()
	if is_instance_valid(target):
		dest = target.get_global_position()
	elif goto_point != Vector2.INF:
		dest = goto_point
	else:
		return
	var cur_speed = wander_speed
	if is_instance_valid(target):
		cur_speed = speed
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

func relay():
	goto_random_zone(get_tree().get_nodes_in_group("enemy_relay_zones"))

func wander():
	goto_random_zone(get_tree().get_nodes_in_group("enemy_cat_zones"))

func kill_target():
	if is_instance_valid(target) && global_position.distance_to(target.global_position) < attack_range:
		target.kill()
		target = null

func find_target():
	var cranes = get_tree().get_nodes_in_group("mooncranes")
	
	var best_crane = null
	var best_distance = INF
	for crane in cranes:
		if crane.exploded:
			continue
		var dist = global_position.distance_to(crane.global_position)
		if dist <= sight_range && dist < best_distance:
			best_distance = dist
			best_crane = crane
	if is_instance_valid(best_crane):
		target = best_crane

