extends Node2D

var firework_scene = preload("res://Abilities/Firework.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2.ZERO
	visible = false
	Global.connect("change_selected_card", self, "_selected_card_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		return
	global_position = get_viewport().get_mouse_position()

func _unhandled_input(event):
	if !visible:
		return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT && is_firework_selected():
			#Release the firework
			var new_firework = firework_scene.instance()
			get_parent().add_child(new_firework)
			new_firework.global_position = Global.selected_card.global_position
			new_firework.target = global_position
			Global.selected_card.discard()

func _selected_card_changed(_old, new):
		visible = is_firework_selected()

func is_firework_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.FIREWORK
