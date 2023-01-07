extends Node2D

signal card_clicked(card)

export(Global.TransitionType) var growTrans = Global.TransitionType.EXPO
export(Global.EaseType) var growEase = Global.EaseType.OUT
export var growTime = 0.2
export var growScale = 2
export var growScaleInactive = 1.1

export(Global.TransitionType) var reseatTrans = Global.TransitionType.EXPO
export(Global.EaseType) var reseatEase = Global.EaseType.IN
export var reseatTime = 0.4

onready var growTween = Tween.new()
onready var reseatTween = Tween.new()

var mouse_over = false
var moused_down = false
var reseat_target = null
export var is_active = true setget set_active

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(growTween)
	add_child(reseatTween)
	set_active(is_active)

func set_active(active: bool):
	is_active = active
	if (is_active):
		$Scaler/CardBack.visible = false
		if mouse_over:
			_on_MouseHoverArea_mouse_entered()
	else:
		$Scaler/CardBack.visible = true
		if mouse_over:
			_on_MouseHoverArea_mouse_entered()

func reseat_to(target, delay=0.0):
	reseat_target = target
	reseatTween.stop_all()
	reseatTween.interpolate_property(self, "global_position", global_position, target.global_position, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_property(self, "global_rotation", global_rotation, target.global_rotation, reseatTime, reseatTrans, reseatEase, delay)
	reseatTween.interpolate_callback(self, reseatTime + delay, "_reseat_done")
	reseatTween.start()

func _reseat_done():
	if !is_instance_valid(reseat_target):
		return
	position = Vector2.ZERO
	rotation = 0
	get_parent().remove_child(self)
	reseat_target.add_child(self)
	
func _on_MouseSelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			if event.pressed:
				moused_down = true
			else:
				if moused_down:
					emit_signal("card_clicked", self)
					print("Card clicked")
				moused_down = false

func _on_MouseSelectArea_mouse_exited() -> void:
	moused_down = false

func _on_MouseHoverArea_mouse_entered() -> void:
	mouse_over = true
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

func _on_MouseHoverArea_mouse_exited() -> void:
	mouse_over = false
	growTween.stop_all()
	growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2.ONE, growTime, growTrans, growEase)
	growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
	growTween.start()
