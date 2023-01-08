extends Control

export var unaffordable_modulation = Color(0.5, 0.5, 0.5)

onready var shop_cards = get_tree().get_nodes_in_group("shop_cards")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("coin_changed", self, "_coin_changed")
	_coin_changed(Global.coin)
	for card in shop_cards:
		card.connect("card_clicked", self, "_card_clicked")

func _coin_changed(coin):
	$NinePatchRect/Gold.text = String(coin)
	for card in shop_cards:
		if card.coin_cost() > coin:
			card.modulate = unaffordable_modulation
		else:
			card.modulate = Color.white

func _card_clicked(card):
	if Global.coin >= card.coin_cost():
		Global.add_card_to_deck(card.get_type())
		Global.coin -= card.coin_cost()
