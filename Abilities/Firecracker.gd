extends Node2D

export var cracker_radius = 200.0

var playspeed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Crackle.play("Crackle", -1, playspeed)

func _process(delta: float) -> void:
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var dist = $Center.global_position.distance_to(enemy.global_position)
		if dist < cracker_radius:
			#Force them to run!
			enemy.relay()

func _on_Crackle_animation_finished(anim_name: String) -> void:
	print("Free Firecracker")
	queue_free()
