extends Node2D

var playspeed = 0.25

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Crackle.play("Crackle", -1, playspeed)


func _on_Crackle_animation_finished(anim_name: String) -> void:
	print("Free Firecracker")
	queue_free()
