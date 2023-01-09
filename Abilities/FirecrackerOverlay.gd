extends Node2D

export var mouse_range = 400.0

var firecracker_scene = preload("res://Abilities/Firecracker.tscn")

onready var initial_modulation = modulate

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible = false
	Global.connect("change_selected_card", self, "_selected_card_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !visible:
		return
	if get_viewport().get_mouse_position().distance_to(global_position) > mouse_range:
		modulate = initial_modulation
	else:
		modulate = Color.white

func _unhandled_input(event):
	if !visible:
		return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT && is_firecracker_selected():
			if get_viewport().get_mouse_position().distance_to(global_position) > mouse_range:
				return
			#Fire the firecracker
			var new_firecracker = firecracker_scene.instance()
			get_parent().add_child(new_firecracker)
			new_firecracker.global_position = global_position
			Global.selected_card.discard()

func _selected_card_changed(_old, new):
	visible = is_firecracker_selected()

func is_firecracker_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.FIRECRACKER
