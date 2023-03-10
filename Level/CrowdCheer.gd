extends Node2D

export var is_left = false
export var cheer_range = 350.0
export var positive_weak_cheer_range = 550.0
export var tween_time = 0.3

export var base_cheer = 0.25
export var max_cheer = 0.7
export var min_cheer = 0.0
export var max_color = Color("ffe600")
export var min_color = Color.black

var last_modulate

onready var modtween = Tween.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	last_modulate = get_parent().modulate
	add_child(modtween)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	get_cheer()
	var new_modulate
	if is_left:
		new_modulate = get_interpolated_color(Global.cheer_left)
	else:
		new_modulate = get_interpolated_color(Global.cheer_right)
	if last_modulate != new_modulate:
		last_modulate = new_modulate
		modtween.stop_all()
		modtween.interpolate_property(get_parent(), "modulate", get_parent().modulate, new_modulate, tween_time, Tween.TRANS_EXPO, Tween.EASE_OUT)
		modtween.start()

func get_cheer():
	var cheers = get_tree().get_nodes_in_group("cheers")
	var total_cheer = base_cheer
	for cheer in cheers:
		var dist = global_position.distance_to(cheer.global_position)
		var cheeramount = cheer.cheer()
		if dist < cheer_range:
			total_cheer += cheeramount
		elif cheeramount > 0 && dist < positive_weak_cheer_range:
			total_cheer += cheeramount/3.0
	if total_cheer < min_cheer:
		total_cheer = min_cheer
	if total_cheer > max_cheer:
		total_cheer = max_cheer
		
	if is_left:
		Global.cheer_left = total_cheer
	else:
		Global.cheer_right = total_cheer

func get_interpolated_color(cheer):
	var color = Color()
	color.a = get_interpolated(min_cheer, max_cheer, cheer, min_color.a, max_color.a)
	color.r = get_interpolated(min_cheer, max_cheer, cheer, min_color.r, max_color.r)
	color.g = get_interpolated(min_cheer, max_cheer, cheer, min_color.g, max_color.g)
	color.b = get_interpolated(min_cheer, max_cheer, cheer, min_color.b, max_color.b)
	return color
	
func get_interpolated(minin, maxin, inval, minout, maxout) -> float:
	var interpval = 0.0
	if inval <= minin:
		interpval =  0.0
	if inval >= maxin:
		interpval =  1.0
	interpval = (inval - minin) / (maxin - minin)
	interpval = interpval * (maxout - minout)
	return interpval + minout
