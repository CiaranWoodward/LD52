extends Node2D

export(Global.TransitionType) var growTrans = Global.TransitionType.EXPO
export(Global.EaseType) var growEase = Global.EaseType.OUT
export var growTime = 0.2
export var growScale = 2.0
export var growScaleInactive = 1.1

onready var growTween = Tween.new()
onready var baseRotation = rotation

var mouse_over = false
export var is_active = true setget set_active

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(growTween)
	set_active(is_active)

func set_active(active: bool):
	is_active = active
	if (is_active):
		$Scaler/CardBack.visible = false
	else:
		$Scaler/CardBack.visible = true
		if mouse_over:
			_on_MouseHoverArea_mouse_entered()

func _on_MouseSelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.

func _on_MouseHoverArea_mouse_entered() -> void:
	mouse_over = true
	if is_active:
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScale, growScale), growTime, growTrans, growEase)
		growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
		growTween.start()
	else:
		growTween.stop_all()
		growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScaleInactive, growScaleInactive), growTime, growTrans, growEase)
		growTween.start()

func _on_MouseHoverArea_mouse_exited() -> void:
	mouse_over = false
	growTween.stop_all()
	growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2.ONE, growTime, growTrans, growEase)
	growTween.interpolate_property(self, "rotation", rotation, baseRotation, growTime, growTrans, growEase)
	growTween.start()
