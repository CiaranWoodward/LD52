extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$"HandLoc/1/Card".connect("card_clicked", self, "card_clicked")

func card_clicked(card):
	card.is_active = false
	card.reseat_to($DiscardPileLoc)
