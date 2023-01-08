extends Control

onready var deck_container = $"GreyOut/Backing/VBox/DeckFloor/Deck/DeckScroller/DeckContainer"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawn_global_deck()

func spawn_global_deck():
	deck_container.spawn_global_deck()

func _on_NextLevel_pressed() -> void:
	print("Next Level!")
