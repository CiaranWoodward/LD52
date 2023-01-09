extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
		Global.connect("moon_health_changed", self, "_moon_health_changed")

func _moon_health_changed():
	seek((1.0-Global.portal_size) * 0.8, true)
	if Global.portal_size == 0.0:
		play("PortalClose")
