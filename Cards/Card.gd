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
	get_parent().remove_child(self)
	target.add_child(self)
	global_position = pos
	global_rotation = rot

func reseat_to(target, delay=0.0, offset=Vector2.ZERO, rotationoffset=0.0, callback=null):
	reseat_target = target
	reseat_offset = offset
	reseat_rotationoffset = rotationoffset
	reseat_callback = callback
	var reseatTime = rand_range(reseatTimeLow, reseatTimeHigh)
	set_mousehover_ignore(true)
	reseatTween.stop_all()
	reseatTween.interpolate_property(self, "global_position", global_position, target.global_position + offset, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_property(self, "global_rotation", global_rotation, target.global_rotation + rotationoffset, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_callback(self, reseatTime + delay, "_reseat_done")
	reseatTween.start()
	return reseatTime + delay

func _reseat_done():
	set_mousehover_ignore(false)
	if is_instance_valid(reseat_target) && reseat_target != get_parent():
		position = reseat_offset
		rotation = reseat_rotationoffset
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

func grow_card() -> void:
	if is_active:
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScale, growScale), growTime, growTrans, growEase)
		growTween.interpolate_property(self, "global_rotation", global_rotation, 0, growTime, growTrans, growEase)
		growTween.start()
	else:
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScaleInactive, growScaleInactive), growTime, growTrans, growEase)
		growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
		growTween.start()

func shrink_card() -> void:
	growTween.stop_all()
	growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2.ONE, growTime, growTrans, growEase)
	growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
	growTween.start()
