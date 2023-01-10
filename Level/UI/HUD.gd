extends Node2D

onready var _discard = $DiscardPile
onready var _draw = $DrawPile
onready var _hand = $Hand

var cheerless_time = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.hud = self
	_draw.connect("cards_added", self, "_draw_replaced")
	add_fresh_deck_to_discard_pile()

func _process(delta: float) -> void:
	var total_cheer = Global.cheer_left + Global.cheer_right
	if total_cheer < 0.05:
		cheerless_time += delta
	elif total_cheer > 0.15:
		cheerless_time = 0
	if cheerless_time > min(Global.spirit, 3):
		Global.remove_deck_from_tree()
		get_tree().change_scene("res://Screens/WinLose.tscn")

func add_fresh_deck_to_discard_pile():
	# First remove all of the cards from the screen (this should just be the editor placeholders!)
	Global.remove_all_children(_draw)
	Global.remove_all_children(_discard)
	_hand.drop_cards()
	
	# Then prepare and store the global deck in the discard pile
	_discard.spawn_global_deck()
	
	# Immediately start the shuffle to the Draw pile which will also fill the hand
	replace_draw()

func discard(card):
	card.is_active = false
	Global.spirit -= card.spirit_cost()
	card.reseat_to(_discard, 0.0, _discard.get_next_offset(), _discard.get_random_rotation(), funcref(self, "_card_discarded"))

func _card_discarded():
	draw_card()

func replace_draw():
	if _draw.get_count() == 0:
		_draw.add_shuffled_cards(_discard.cards())
		$SoundShuffle.play()

func _draw_replaced():
	draw_card()

func replace_hand():
	replace_draw()
	for slot in _hand.empty_slots():
		_draw.get_next_card().reseat_to(slot)
		replace_draw()

func draw_card():
	if _hand.empty_slot_count() == 0:
		return
	if _draw.get_count() == 0:
		replace_draw()
		return
	#Immediately put the card in the hand for tracking, then animate it
	var handslot = _hand.empty_slots()[0]
	var card = _draw.get_next_card()
	card.is_active = true
	card.instant_transfer(handslot)
	card.reseat_to(handslot, 0.0, Vector2.ZERO, 0.0, funcref(self, "_card_drawn"))

func _card_drawn():
	draw_card()
