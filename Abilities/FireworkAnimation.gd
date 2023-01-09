extends AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func randomize_explosion_pitch():
	$"../SoundExplosion".pitch_scale = rand_range(0.8, 1.2)
