extends Node2D

var apocalypse = Timer.new()
var cat = Timer.new()
var pig = Timer.new()
var fox = Timer.new()
var fade_out_tween = Tween.new()
onready var spawnpoint = $Background/Landscape/Spawn

var fox_scene = preload("res://Enemies/Fox.tscn")
var cat_scene = preload("res://Enemies/Cat.tscn")
var pig_scene = preload("res://Enemies/Pig.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("moon_health_changed", self, "_moon_health_changed")
	Global.max_moon_health = 30
	Global.moon_health = 30
	add_child(apocalypse)
	add_child(cat)
	add_child(pig)
	add_child(fox)
	add_child(fade_out_tween)
	apocalypse.connect("timeout", self, "apocotime")
	cat.connect("timeout", self, "cattime")
	pig.connect("timeout", self, "pigtime")
	fox.connect("timeout", self, "foxtime")
	apocalypse.start(400)
	cat.start(20)
	pig.start(30)
	fox.start(5)

func apocotime():
	spawn(fox_scene)
	apocalypse.start(5)

func cattime():
	spawn(cat_scene)
	cat.start(60)

func pigtime():
	spawn(pig_scene)
	pig.start(40)

func foxtime():
	spawn(fox_scene)
	fox.start(30)

func spawn(scene):
	var newscene = scene.instance()
	add_child(newscene)
	newscene.global_position = spawnpoint.global_position

var exited = false
func _moon_health_changed():
	if exited: return
	if Global.moon_health <= 0:
		exited = true
		Global.next_level_path = "res://Level/Level2.tscn"
		fade_out_tween.stop_all()
		fade_out_tween.interpolate_property($LevelIntro/Grey, "modulate", Color.transparent, Color("212121"), 0.5)
		fade_out_tween.interpolate_callback(self, 0.6, "exitnow")
		fade_out_tween.start()

func exitnow():
	Global.remove_deck_from_tree()
	get_tree().change_scene("res://Screens/WinLose.tscn")
