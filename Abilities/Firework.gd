extends Node2D

export var speed = 350

var target : Vector2 setget set_target

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func set_target(newtarget):
	target = newtarget
	$Rocket.set_rotation(global_position.angle_to_point(target) - (PI/2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var distance_covered = delta * speed
	var distance_left = global_position.distance_to(target)
	var direction = global_position.direction_to(target)
	if distance_left <= distance_covered:
		global_position = target
		explode()
	else:
		global_position += direction * distance_covered

func explode():
	$Firework.visible = true
	$Rocket.self_modulate = Color.transparent
	$AnimationPlayer.play("Explode")
	$Explosion.rotation = rand_range(0, 2 * PI)
	if (randi() % 2 == 1):
		$Explosion.scale.x = -1

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print("Free Firework")
	queue_free()
