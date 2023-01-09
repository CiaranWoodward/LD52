extends Node2D

onready var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2.ZERO
	add_child(tween)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT && is_dragon_selected():
			#Release the DRAGON
			$Body.visible = true
			$Body.cheerval = Global.selected_card.cheer()
			$Spawn.play()
			var lifetime = Global.selected_card.lifetime()
			tween.stop_all()
			tween.interpolate_callback(self, lifetime, "end_dragon")
			tween.start()
			Global.selected_card.discard()

func end_dragon():
	$Body.visible = false

func is_dragon_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.DRAGON
