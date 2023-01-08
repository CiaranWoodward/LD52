extends Node2D
class_name Card

signal card_clicked(card)

export(Global.TransitionType) var growTrans = Global.TransitionType.EXPO
export(Global.EaseType) var growEase = Global.EaseType.OUT
export var growTime = 0.2
export var growScale = 2.0
export var growScaleInactive = 1.1

export(Global.TransitionType) var reseatTrans = Global.TransitionType.BACK
export(Global.EaseType) var reseatEase = Global.EaseType.IN
export var reseatTimeLow = 0.4
export var reseatTimeHigh = 0.6

onready var growTween = Tween.new()
onready var reseatTween = Tween.new()

var card_dragon = preload("res://Cards/Dragon.tscn")
var card_firecracker = preload("res://Cards/Firecracker.tscn")
var card_firework = preload("res://Cards/Firework.tscn")
var card_lantern = preload("res://Cards/Lantern.tscn")
var card_lightstall = preload("res://Cards/LightStall.tscn")
var card_mooncakestall = preload("res://Cards/MooncakeStall.tscn")
var card_mooncrane = preload("res://Cards/MoonCrane.tscn")

var mouse_over = false
var moused_down = false
var reseat_target = null
var reseat_offset = Vector2.ZERO
var reseat_rotationoffset = 0
var reseat_callback = null
export var is_active = true setget set_active
var mousehover_ignore = false setget set_mousehover_ignore

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(growTween)
	add_child(reseatTween)
	set_active(is_active)
	Global.connect("unhovered_card", self, "_other_card_unhovered")

func set_type(type):
	var newtype
	Global.remove_all_children($Scaler/CardFront, true)
	match type:
		Global.CardType.DRAGON:
			newtype = card_dragon.instance()
		Global.CardType.FIRECRACKER:
			newtype = card_firecracker.instance()
		Global.CardType.FIREWORK:
			newtype = card_firework.instance()
		Global.CardType.LANTERN:
			newtype = card_lantern.instance()
		Global.CardType.LIGHT_STALL:
			newtype = card_lightstall.instance()
		Global.CardType.CAKE_STALL:
			newtype = card_mooncakestall.instance()
		Global.CardType.CRANE:
			newtype = card_mooncrane.instance()
		_:
			assert(false)
	$Scaler/CardFront.add_child(newtype)

func set_active(active: bool):
	is_active = active
	$MouseHoverArea/ActiveHoverShape.set_deferred("disabled", !active)
	$MouseHoverArea/InactiveHoverShape.set_deferred("disabled", active)
	if (is_active):
		$Scaler/CardBack.visible = false
		if mouse_over && !mousehover_ignore:
			grow_card()
	else:
		$Scaler/CardBack.visible = true
		Global.unhover_card(self)
		z_index = 0
		if mouse_over && !mousehover_ignore:
			grow_card()

func set_mousehover_ignore(newval: bool):
	mousehover_ignore = newval
	if mousehover_ignore:
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2.ONE, growTime, growTrans, growEase)
		growTween.start()

func instant_transfer(target):
	if target == get_parent():
		return
	var pos = global_position
	var rot = global_rotation
	var scale_ = global_scale
	get_parent().remove_child(self)
	target.add_child(self)
	global_position = pos
	global_rotation = rot
	global_scale = scale_

func reseat_to(target, delay=0.0, offset=Vector2.ZERO, rotationoffset=0.0, callback=null):
	reseat_target = target
	reseat_offset = offset
	reseat_rotationoffset = rotationoffset
	reseat_callback = callback
	var reseatTime = rand_range(reseatTimeLow, reseatTimeHigh)
	set_mousehover_ignore(true)
	reseatTween.stop_all()
	reseatTween.interpolate_property(self, "global_scale", global_scale, target.global_scale, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_property(self, "global_position", global_position, target.global_position + offset, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_property(self, "global_rotation", global_rotation, target.global_rotation + rotationoffset, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_callback(self, reseatTime + delay, "_reseat_done")
	reseatTween.start()
	return reseatTime + delay

func _reseat_done():
	set_mousehover_ignore(false)
	$SoundSoftPlace.pitch_scale = rand_range(0.8, 1.2)
	$SoundSoftPlace.play()
	if is_instance_valid(reseat_target) && reseat_target != get_parent():
		position = reseat_offset
		rotation = reseat_rotationoffset
		scale = Vector2.ONE
		get_parent().remove_child(self)
		reseat_target.add_child(self)
	if is_instance_valid(reseat_callback):
		reseat_callback.call_deferred("call_func")
	
func _on_MouseSelectArea_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if !is_active:
		return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				moused_down = true
			else:
				if moused_down:
					$SoundClick.pitch_scale = rand_range(1, 1.1)
					$SoundClick.play()
					emit_signal("card_clicked", self)
				moused_down = false

func _on_MouseSelectArea_mouse_exited() -> void:
	moused_down = false

func _on_MouseHoverArea_mouse_entered() -> void:
	mouse_over = true
	if !mousehover_ignore:
		grow_card()

func _on_MouseHoverArea_mouse_exited() -> void:
	mouse_over = false
	if !mousehover_ignore:
		shrink_card()

func _other_card_unhovered():
	if !mousehover_ignore && mouse_over && is_active && Global.hover_card(self):
		grow_card()

func grow_card() -> void:
	if is_active && Global.hover_card(self):
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScale, growScale), growTime, growTrans, growEase)
		growTween.interpolate_property(self, "global_rotation", global_rotation, 0, growTime, growTrans, growEase)
		growTween.start()
		z_index = 1
	else:
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScaleInactive, growScaleInactive), growTime, growTrans, growEase)
		growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
		growTween.start()
	$SoundHover.pitch_scale = rand_range(1.3, 1.8)
	$SoundHover.play()

func shrink_card() -> void:
	Global.unhover_card(self)
	growTween.stop_all()
	growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2.ONE, growTime, growTrans, growEase)
	growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
	growTween.start()
	z_index = 0
