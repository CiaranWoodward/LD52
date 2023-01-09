extends KinematicBody2D

export var active = true
export var speed = -50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if !active:
		collision_layer = 0
		collision_mask = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active:
		return
	var col = move_and_collide(Vector2(0, speed)*delta)
	if col:
		print("We hit!")
	if global_position.y < -100:
		print("Free lantern")
		queue_free()
