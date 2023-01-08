extends Control

export var grow_scale = 1.1
export var grow_scale_inactive = 1.02

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_card(card):
	Global.remove_all_children($CardPlace/CardPoint)
	$CardPlace/CardPoint.add_child(card)
	card.set_position(Vector2.ZERO)
	card.set_scale(Vector2.ONE)
	card.set_rotation(0)
	card.growScale = grow_scale
	card.growScaleInactive = grow_scale_inactive

func ch_remove_self():
	$CardPlace/CardPoint.remove_child($CardPlace/CardPoint/Card)
	get_parent().remove_child(self)
	queue_free()
