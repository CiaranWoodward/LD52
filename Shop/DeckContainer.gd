extends GridContainer

onready var card_holder_scene = preload("res://Shop/CardHolder.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("card_added", self, "add_card_to_container")
	Global.connect("card_removed", self, "remove_card_from_container")

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

func remove_card_from_container(card):
	if !is_a_parent_of(card):
		return
	var iter : Node2D = card.get_parent()
	while is_instance_valid(iter):
		if iter.has_method("ch_remove_self"):
			iter.ch_remove_self()
			break
		iter = iter.get_parent()
