extends AnimationPlayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	autoplay = "Explode"

func randomize_explosion_pitch():
	$"../SoundExplosion".pitch_scale = rand_range(0.8, 1.2)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
