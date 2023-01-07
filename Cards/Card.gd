extends Node2D

export(Global.TransitionType) var growTrans = Global.TransitionType.EXPO
export(Global.EaseType) var growEase = Global.EaseType.OUT
export var growTime = 0.2
export var growScale = 2

onready var growTween = Tween.new()
onready var baseRotation = rotation

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(growTween)

func _on_MouseSelectArea_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	pass # Replace with function body.

func _on_MouseHoverArea_mouse_entered() -> void:
	growTween.stop_all()
	growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2(growScale, growScale), growTime, growTrans, growEase)
	growTween.interpolate_property(self, "rotation", rotation, 0, growTime, growTrans, growEase)
	growTween.start()

func _on_MouseHoverArea_mouse_exited() -> void:
	growTween.stop_all()
	growTween.interpolate_property($Scaler, "scale", $Scaler.scale, Vector2.ONE, growTime, growTrans, growEase)
	growTween.interpolate_property(self, "rotation", rotation, baseRotation, growTime, growTrans, growEase)
	growTween.start()
