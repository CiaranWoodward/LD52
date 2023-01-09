extends Node2D

var cheerval = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cheers")

func cheer():
	if visible:
		return cheerval
	return 0.0
