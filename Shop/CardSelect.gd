extends CanvasLayer

var card = null

func _ready() -> void:
	Global.connect("change_selected_card", self, "_card_changed")
	Global.connect("card_added", self, "_deck_changed")
	Global.connect("card_removed", self, "_deck_changed")

func _card_changed(_old_card, new_card: Node2D):
	if !is_instance_valid(new_card) || !Global.deck.has(new_card):
		visible = false
	else:
		visible = true
		offset = new_card.global_position
		$UpgradeCard/Card.set_type(new_card.get_type())

func _deck_changed(_ignored):
	$DiscardButton.visible = Global.deck.size() > 3

func _on_DiscardButton_pressed() -> void:
	if (is_instance_valid(Global.selected_card)):
		Global.remove_card_from_deck(Global.selected_card)

func _on_UpgradeButton_pressed() -> void:
	print("Todo: Upgrade!")
