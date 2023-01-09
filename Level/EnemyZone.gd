tool
extends Node2D

export var size = Vector2(100,100) setget set_size,get_size
export var type = "relay"
var global_center = global_position + size/2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$BottomRight.position = size
	if Engine.editor_hint:
		return
	add_to_group("enemy_zones")
	add_to_group("enemy_" + type + "_zones")

func set_size(newsize):
	$BottomRight.position = size
	size = newsize

func get_size():
	$BottomRight.position = size
	return size

func get_global_point_in_zone():
	return global_position + Vector2(rand_range(0, size.x), rand_range(0, size.y))
