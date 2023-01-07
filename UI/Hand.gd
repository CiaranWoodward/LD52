extends Position2D



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func slots() -> int:
	return get_child_count()

func empty_slot_count() -> int:
	var count = 0
	for child in get_children():
		if child.get_child_count() == 0:
			count += 1
	return count

func full_slot_count() -> int:
	var count = 0
	for child in get_children():
		if child.get_child_count() > 0:
			count += 1
	return count

func empty_slots() -> Array:
	var arr = []
	for child in get_children():
		if child.get_child_count() == 0:
			arr.append(child)
	return arr
