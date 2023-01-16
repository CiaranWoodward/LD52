extends AnimationPlayer

var seekval = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("moon_health_changed", self, "_moon_health_changed")
	set_current_animation("PortalClose")
	connect("animation_finished", self, "_anim_finished")

func _process(delta):
	var curpos = get_current_animation_position()
	print("curpos: " + str(curpos))
	if curpos < seekval:
		advance(delta)

func _anim_finished(name):
	if seekval == 0.0:
		seek(0.0, true)

func _moon_health_changed():
	self.call_deferred("_update_portal")

func _update_portal():
	seekval = (1.0-Global.portal_size) * 0.8
	#seek(seekval, true)
	if Global.portal_size == 0.0:
		play("PortalClose")
