extends Node2D

export var spirit_level = 1

onready var stateMachine : AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var glowing = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AnimationTree.active = true
	stateMachine.start("Off")
	Global.connect("spirit_changed", self, "_spirit_changed")
	_spirit_changed()

func _spirit_changed():
	if Global.spirit >= spirit_level:
		if !glowing:
			stateMachine.travel("OnBob")
	else:
		if glowing:
			stateMachine.travel("Off")
