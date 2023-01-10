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
		card = $UpgradeCard/Card
		card.set_type(new_card.get_type())
		var upgrade_possible = new_card.upgrade_level() < card.max_upgrade_level()
		card.typeobj.upgrade_level = new_card.upgrade_level() + 1
		card.refresh_gui()
		upgrade_possible = upgrade_possible && Global.coin >= card.coin_cost()
		$UpgradeCard.visible = upgrade_possible

func _deck_changed(_ignored):
	$DiscardButton.visible = Global.deck.size() > 3

func _on_DiscardButton_pressed() -> void:
	if (is_instance_valid(Global.selected_card)):
		Global.remove_card_from_deck(Global.selected_card)

func _on_UpgradeButton_pressed() -> void:
	Global.coin -= card.coin_cost()
	Global.selected_card.typeobj.upgrade_level += 1
	Global.selected_card.refresh_gui()
	visible = false
