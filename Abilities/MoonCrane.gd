extends Node2D

export var speed = 140.0
var target = null
var exploded = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("mooncranes")

func _process(delta: float) -> void:
	if is_instance_valid(target):
		var target_pos = target.target_position()
		var distance_covered = delta * speed
		var distance_left = global_position.distance_to(target_pos)
		var direction = global_position.direction_to(target_pos)
		if distance_left <= (distance_covered + target.mooncrane_hit_range):
			explode()
		global_position += direction * distance_covered
	else:
		target = find_new_target()

func play_random_flap():
	var flaps = [$Flap1, $Flap2, $Flap3, $Flap4]
	flaps.shuffle()
	flaps[0].play()

func find_new_target():
	var best_target = null
	var best_distance = INF
	var targets = get_tree().get_nodes_in_group("mooncrane_targets")
	for target in targets:
		var dist = global_position.distance_to(target.target_position())
		if dist < best_distance:
			best_distance = dist
			best_target = target
	return best_target

func explode():
	if exploded:
		return
	exploded = true
	$Flap.play("Die")

func kill():
	if exploded:
		return
	exploded = true
	$Flap.play("Die")

func _on_Flap_animation_finished(anim_name: String) -> void:
	if anim_name == "Die":
		print("Mooncrane Freed")
		queue_free()
