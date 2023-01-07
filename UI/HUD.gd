extends Node2D

onready var _discard = $DiscardPile
onready var _draw = $DrawPile
onready var _hand = $Hand

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	randomize()
	$"Hand/1/Card".connect("card_clicked", self, "card_clicked")
	$"Hand/2/Card2".connect("card_clicked", self, "card_clicked")
	$"Hand/3/Card3".connect("card_clicked", self, "card_clicked")
	$"DiscardPile/Card4".connect("card_clicked", self, "card_clicked")
	$"DrawPile/Card5".connect("card_clicked", self, "card_clicked")
	$"DrawPile/Card6".connect("card_clicked", self, "card_clicked")
	_draw.connect("cards_added", self, "_draw_replaced")

func card_clicked(card):
	discard(card)

func discard(card: Card):
	card.is_active = false
	card.reseat_to(_discard, 0.0, _discard.get_next_offset(), _discard.get_random_rotation(), funcref(self, "_card_discarded"))

func _card_discarded():
	draw_card()

func replace_draw():
	if _draw.get_count() == 0:
		_draw.add_shuffled_cards(_discard.cards())

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
