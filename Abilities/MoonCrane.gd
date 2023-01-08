extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_random_flap():
	var flaps = [$Flap1, $Flap2, $Flap3, $Flap4]
	flaps.shuffle()
	flaps[0].play()
	
