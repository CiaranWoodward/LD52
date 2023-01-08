extends GridContainer

onready var card_holder_scene = preload("res://Shop/CardHolder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawn_global_deck():
	Global.remove_deck_from_tree()
	Global.remove_all_children(self, true)
	Global.sort_deck()
	for card in Global.deck:
		add_card_to_container(card)

func add_card_to_container(card):
	var cardholder = card_holder_scene.instance()
	cardholder.set_card(card)
	add_child(cardholder)
