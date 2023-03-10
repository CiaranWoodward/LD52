extends Position2D

export var spacing: Vector2 = Vector2(9,1)
export var rand_rotation: float = 0.3

var current_offset: Vector2 = Vector2.ZERO
var count: int setget ,get_count

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func get_count() -> int:
	return get_child_count()

func cards():
	return get_children()

func get_next_offset() -> Vector2:
	return get_count() * spacing

func get_random_rotation() -> float:
	return rand_range(-rand_rotation, rand_rotation)

func spawn_global_deck():
	Global.remove_deck_from_tree()
	for card in Global.deck:
		add_child(card)
		card.is_active = false
		card.position = get_next_offset()
		card.rotation = get_random_rotation()
		card.scale = Vector2.ONE
