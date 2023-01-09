extends Node2D

var mouse_over = false
var stall_selected = false
var type = Global.CardType.CAKE_STALL

var mooncake_stock = 0.0
var lantern_stock = 0.0
var decay_rate = 0.15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("change_selected_card", self, "_selected_card_changed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mooncake_stock -= decay_rate * delta
	lantern_stock -= decay_rate * delta
	if mooncake_stock < 0.0:
		mooncake_stock = 0.0
	if lantern_stock < 0.0:
		lantern_stock = 0.0
	update_stock()

func update_stock():
	if mooncake_stock == 0:
		$Sprite/Mooncake.visible = false
	else:
		$Sprite/Mooncake.visible = true
		$Sprite/Mooncake/Full.modulate.a = get_alpha(0.5, 1.0, mooncake_stock)
		$Sprite/Mooncake/Half.modulate.a = get_alpha(0.0, 0.5, mooncake_stock)

	if lantern_stock == 0:
		$Sprite/Lantern.visible = false
	else:
		$Sprite/Lantern.visible = true
		$Sprite/Lantern/Full.modulate.a = get_alpha(0.5, 1.0, lantern_stock)
		$Sprite/Lantern/Half.modulate.a = get_alpha(0.0, 0.5, lantern_stock)

func get_alpha(minrange, maxrange, currange) -> float:
	if currange <= minrange:
		return 0.0
	if currange >= maxrange:
		return 1.0
	return (currange - minrange) / (maxrange - minrange)

func _unhandled_input(event):
	if !visible:
		return
	if event is InputEventMouseButton:
		if !event.pressed and event.button_index == BUTTON_LEFT && mouse_over && stall_selected:
			#Stock the stall
			var lifetime = Global.selected_card.lifetime()
			if lifetime == 0: lifetime = 5
			decay_rate =  1/lifetime
			if type == Global.CardType.LIGHT_STALL:
				lantern_stock = 1.0
				mooncake_stock = 0.0
			else:
				mooncake_stock = 1.0
				lantern_stock = 0.0
			Global.selected_card.discard()

func _selected_card_changed(_old, new):
		stall_selected = is_stall_selected()
		$GlowParent.active = stall_selected

func is_stall_selected() -> bool:
	if !is_instance_valid(Global.selected_card):
		return false
	if (Global.selected_card.card_type() == Global.CardType.CAKE_STALL || Global.selected_card.card_type() == Global.CardType.LIGHT_STALL):
		type = Global.selected_card.card_type()
		return true
	return false

func _on_Area2D_mouse_entered() -> void:
	mouse_over = true

func _on_Area2D_mouse_exited() -> void:
	mouse_over = false
