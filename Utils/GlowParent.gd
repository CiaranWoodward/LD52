extends Node2D

export var period = 0.5
export var color = Color(0.9, 0.9, 0.8)
export var active = true setget set_active

onready var glow_tween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(glow_tween)
	if active:
		GlowUp()

func set_active(newval):
	if newval == active:
		return
	active = newval
	if active:
		GlowUp()
	else:
		glow_tween.stop_all()

func GlowUp():
	var p = get_parent()
	glow_tween.stop_all()
	glow_tween.interpolate_property(p, "modulate", p.modulate, color, period, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	glow_tween.interpolate_callback(self, period, "GlowDown")
	glow_tween.start()
	
func GlowDown():
	var p = get_parent()
	glow_tween.stop_all()
	glow_tween.interpolate_property(p, "modulate", p.modulate, Color.white, period, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	glow_tween.interpolate_callback(self, period, "GlowUp")
	glow_tween.start()
