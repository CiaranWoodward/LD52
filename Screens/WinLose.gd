extends Control

func _ready() -> void:
	if Global.game_completed:
		$MarginContainer/Win.visible = false
		$MarginContainer/Lose.visible = false
		$MarginContainer/Completed.visible = true
		$WinMusic.play()
	elif Global.moon_health <= 0:
		$MarginContainer/Win.visible = true
		$MarginContainer/Lose.visible = false
		$MarginContainer/Completed.visible = false
		$WinMusic.play()
	else:
		$MarginContainer/Win.visible = false
		$MarginContainer/Lose.visible = true
		$MarginContainer/Completed.visible = false
		$LoseMusic.play()

func _on_TextureButton_pressed() -> void:
	get_tree().change_scene("res://Shop/Shop.tscn")
