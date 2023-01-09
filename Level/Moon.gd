extends Sprite

export var mooncrane_priority = 1
export var mooncrane_hit_range = 170.0

var _mouse_over = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.connect("change_selected_card", self, "_selected_card_changed")
	$MooncraneTarget.connect("mouse_entered", self, "_mouseentered")
	$MooncraneTarget.connect("mouse_exited", self, "_mouseexited")
	is_mooncrane_selected()

func is_under_mouse() -> bool:
	return _mouse_over

func target_position():
	return $MooncraneTarget.global_position

func _mouseentered():
	_mouse_over = true
	
func _mouseexited():
	_mouse_over = false

func _selected_card_changed(_old, new):
	$TargetGlow.active = is_mooncrane_selected()

func is_mooncrane_selected() -> bool:
	return is_instance_valid(Global.selected_card) && Global.selected_card.card_type() == Global.CardType.CRANE

func damage(damage):
	pass
