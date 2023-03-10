extends Node2D

export var speed = 350
export var damage_range = 150.0
var exploded = false

var damage = 10
var cheerval = 0.3
var target : Vector2 setget set_target

var possible_colors = [
	Color("fa2111"),
	Color("1182fa"),
	Color("f811fa"),
	Color("11fa25"),
	Color("b25bf9"),
	Color("fff342"),
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cheers")
	$SoundTrail.pitch_scale = rand_range(0.8, 1.2)
	$SoundTrail.play()
	possible_colors.shuffle()
	var col = possible_colors[0]
	$Firework.self_modulate = col
	$Rocket.self_modulate = col

func set_target(newtarget):
	target = newtarget
	$Rocket.set_rotation(global_position.angle_to_point(target) - (PI/2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exploded:
		return
	var distance_covered = delta * speed
	var distance_left = global_position.distance_to(target)
	var direction = global_position.direction_to(target)
	if distance_left <= distance_covered:
		global_position = target
		explode()
	else:
		global_position += direction * distance_covered

func explode():
	cause_damage()
	exploded = true
	$SoundTrail.stop()
	$Firework.visible = true
	$Rocket.self_modulate = Color.transparent
	$AnimationPlayer.play("Explode")
	$Firework.rotation = rand_range(0, 2 * PI)
	if (randi() % 2 == 1):
		$Firework.scale.x = -$Firework.scale.x

func cause_damage():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < damage_range:
			enemy.damage(damage)

func cheer():
	if exploded:
		return cheerval
	return 0.0

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	print("Free Firework")
	queue_free()
