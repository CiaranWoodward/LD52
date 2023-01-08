extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("coin_changed", self, "_coin_changed")
	_coin_changed(Global.coin)

func _coin_changed(coin):
	$NinePatchRect/Gold.text = String(coin)
