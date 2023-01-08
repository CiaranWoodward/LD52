extends CanvasLayer

var card = null

func _ready() -> void:
	Global.connect("change_selected_card", self, "_card_changed")

func _card_changed(_old_card, new_card: Node2D):
	if !is_instance_valid(new_card) || !Global.deck.has(new_card):
		visible = false
	else:
		visible = true
		offset = new_card.global_position
		$UpgradeCard/Card.set_type(new_card.get_type())
