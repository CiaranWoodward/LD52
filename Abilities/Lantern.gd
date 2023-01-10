extends KinematicBody2D

export var active = true
export var speed = -50

export var trigger_range = 80.0
export var damage_range = 120.0
var exploded = false
var damage = 10
var cheerval = 0.1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("cheers")
	if !active:
		collision_layer = 0
		collision_mask = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !active:
		return
	#we don't actually use this.. whoops
	var col = move_and_collide(Vector2(0, speed)*delta)
	if exploded:
		return	
	if col:
		explode()
	trigger()
	if global_position.y < -100:
		print("Free lantern")
		queue_free()

func trigger():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < trigger_range:
			explode()
			return

func explode():
	cause_damage()
	exploded = true
	$AnimationPlayer.play("Die")
	$SoundDie.pitch_scale = rand_range(0.8, 1.2)
	$SoundDie.play()

func cause_damage():
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < damage_range:
			enemy.damage(damage)

func cheer():
	if exploded:
		return cheerval*2
	return cheerval

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "Die":
		print("Free lantern")
		queue_free()
