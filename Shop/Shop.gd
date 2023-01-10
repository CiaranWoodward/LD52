extends Control

onready var deck_container = $"GreyOut/Backing/VBox/DeckFloor/Deck/DeckScroller/DeckContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.spirit = 10
	if Global.coin < 10:
		Global.coin = 10
	spawn_global_deck()

func spawn_global_deck():
	deck_container.spawn_global_deck()

func _on_NextLevel_pressed() -> void:
	Global.remove_deck_from_tree()
	Global.spirit = 3
	get_tree().change_scene(Global.next_level_path)
