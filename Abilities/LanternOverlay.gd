extends Node2D

var lantern_scene = preload("res://Abilities/Lantern.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position = Vector2.ZERO
	visible = false
	Global.connect("change_selected_card", self, "_selected_card_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		return
	global_position.x = get_viewport().get_mouse_position().x - 38

func _unhandled_input(event):
	if !visible:
		return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT && is_lantern_selected():
			#Release the balloon
			var new_lantern = lantern_scene.instance()
			get_parent().add_child(new_lantern)
			new_lantern.global_position = $Lantern.global_position
			new_lantern.cheerval = Global.selected_card.cheer()
			new_lantern.damage = Global.selected_card.damage()
			Global.selected_card.discard()

func _selected_card_changed(_old, new):
		visible = is_lantern_selected()

func is_lantern_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.LANTERN
