extends Position2D

signal cards_added

export var spacing: Vector2 = Vector2(9,1)
export var rand_rotation: float = 0.3
export var rand_add_delay: float = 0.3

var current_offset: Vector2 = Vector2.ZERO
var count: int setget _noset,get_count
var adding_cards: bool = false setget _noset

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# generic setter which just asserts if setting something you shouldn't
func _noset(_val):
	assert(false)

func get_count() -> int:
	if adding_cards:
		return 0
	return get_child_count()

func get_next_offset() -> Vector2:
	return get_count() * spacing

func get_random_rotation() -> float:
	return rand_range(-rand_rotation, rand_rotation)

func add_shuffled_cards(cards):
	if adding_cards:
		return
	assert(get_count() == 0)
	cards.shuffle()
	var curcount = 0
	var longest_delay = 0.0
	var longest_reseat = null
	adding_cards = true
	for card in cards:
		var delay = rand_range(0.0, rand_add_delay)
		var offset = curcount * spacing
		var rotate_offset = rand_range(-rand_rotation, rand_rotation)
		var reseat_time
		curcount += 1
		card.instant_transfer(self)
		reseat_time = card.reseat_to(self, delay, offset, rotate_offset)
		if reseat_time > longest_delay:
			longest_delay = reseat_time
			longest_reseat = card
	if is_instance_valid(longest_reseat):
		longest_reseat.reseat_callback = funcref(self, "_cards_added")

func _cards_added():
	adding_cards = false
	emit_signal("cards_added")

func get_next_card():
	var ccount = get_count()
	if ccount == 0:
		return null
	return get_child(ccount-1)
