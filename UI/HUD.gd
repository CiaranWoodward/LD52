extends Node2D

onready var _discard = $DiscardPile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"HandLoc/1/Card".connect("card_clicked", self, "card_clicked")
	$"HandLoc/2/Card2".connect("card_clicked", self, "card_clicked")
	$"HandLoc/3/Card3".connect("card_clicked", self, "card_clicked")

func card_clicked(card):
	discard(card)

func discard(card: Card):
	card.is_active = false
	card.reseat_to(_discard, 0.0, _discard.get_next_offset(), _discard.get_random_rotation()) 
