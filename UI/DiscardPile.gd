extends Position2D

export var spacing: Vector2 = Vector2(9,1)
export var rand_rotation: float = 0.3

var current_offset: Vector2 = Vector2.ZERO
var count: int setget ,count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func count() -> int:
	return get_child_count()

func get_next_offset() -> Vector2:
	return count() * spacing

func get_random_rotation() -> float:
	return rand_range(-rand_rotation, rand_rotation)
