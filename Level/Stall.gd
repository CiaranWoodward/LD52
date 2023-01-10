extends Node2D

var mouse_over = false
var stall_selected = false
var type = Global.CardType.CAKE_STALL

var mooncake_stock = 0.0
var lantern_stock = 0.0
var decay_rate = 0.15
var cheerval = 0.0
var coin_period = 0.0

onready var tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("change_selected_card", self, "_selected_card_changed")
	add_to_group("stalls")
	add_to_group("cheers")
	add_child(tween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	mooncake_stock -= decay_rate * delta
	lantern_stock -= decay_rate * delta
	if mooncake_stock < 0.0:
		mooncake_stock = 0.0
	if lantern_stock < 0.0:
		lantern_stock = 0.0
	update_stock()

func steal(amount):
	mooncake_stock -= amount
	lantern_stock -= amount
	if mooncake_stock < 0.0:
		mooncake_stock = 0.0
	if lantern_stock < 0.0:
		lantern_stock = 0.0

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
			cheerval = Global.selected_card.cheer()
			coin_period = Global.selected_card.coin_period()
			if lifetime == 0: lifetime = 5
			decay_rate =  1/lifetime
			if type == Global.CardType.LIGHT_STALL:
				lantern_stock = 1.0
				mooncake_stock = 0.0
			else:
				mooncake_stock = 1.0
				lantern_stock = 0.0
			evaluate_coin()
			Global.selected_card.discard()

func evaluate_coin():
	if coin_period != 0 && has_stock():
		tween.stop_all()
		tween.interpolate_callback(self, coin_period, "evaluate_coin")
		tween.start()
		Global.coin += 1
		var sounds = [$CoinGenerate1, $CoinGenerate2, $CoinGenerate3]
		sounds.shuffle()
		var sound = sounds[0]
		sound.pitch_scale = rand_range(0.9, 1.1)
		sound.play()

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

func cheer():
	if has_stock():
		return cheerval
	return 0.0

func has_stock():
	return mooncake_stock > 0 || lantern_stock > 0

func _on_Area2D_mouse_entered() -> void:
	mouse_over = true

func _on_Area2D_mouse_exited() -> void:
	mouse_over = false
