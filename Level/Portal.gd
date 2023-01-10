extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("moon_health_changed", self, "_moon_health_changed")
	set_current_animation("PortalClose")

func _moon_health_changed():
	self.call_deferred("_update_portal")

func _update_portal():
	var seekval = (1.0-Global.portal_size) * 0.8
	seek(seekval, true)
	if Global.portal_size == 0.0:
		play("PortalClose")
