extends Node2D

var mooncrane_scene = preload("res://Abilities/MoonCrane.tscn")

onready var initial_modulation = modulate

var mooncrane_active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("mooncrane_overlays")
	visible = false
	Global.connect("change_selected_card", self, "_selected_card_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !mooncrane_active:
		return
	show_closest_mooncrane()

func _unhandled_input(event):
	if !mooncrane_active || !visible:
		return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT && is_mooncrane_selected():
			var best_target = get_best_target()
			if !is_instance_valid(best_target):
				return
			#Take flight, my sweet mooncrane
			var new_mooncrane = mooncrane_scene.instance()
			get_parent().add_child(new_mooncrane)
			new_mooncrane.global_position = global_position
			new_mooncrane.target = best_target
			Global.selected_card.discard()

func get_best_target():
	var best_target = null
	var best_priority = -999
	var targets = get_tree().get_nodes_in_group("mooncrane_targets")
	for target in targets:
		if target.is_under_mouse():
			if target.mooncrane_priority > best_priority:
				best_priority = target.mooncrane_priority
				best_target = target
	return best_target

func show_closest_mooncrane():
	var mooncranes = get_tree().get_nodes_in_group("mooncrane_overlays")
	if mooncranes[0] != self:
		return
	var closest = self
	var min_dist = distance_to_mouse()
	for mc in mooncranes:
		var dist = mc.distance_to_mouse()
		if dist < min_dist:
			min_dist = dist
			closest = mc
		mc.visible = false
	closest.visible = true

func distance_to_mouse():
	return get_viewport().get_mouse_position().distance_to(global_position)

func _selected_card_changed(_old, new):
	mooncrane_active = is_mooncrane_selected()
	if !mooncrane_active:
		visible = false

func is_mooncrane_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.CRANE
