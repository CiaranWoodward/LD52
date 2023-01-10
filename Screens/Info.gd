extends Control

# Called when the node enters the scene tree for the first time.
func _process(_d) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene("res://Level/Level.tscn")

func _on_Info_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT && event.pressed == false:
			get_tree().change_scene("res://Level/Level.tscn")
