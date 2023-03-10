extends ScrollContainer

export var scroll_speed = 120.0

onready var scrollTween = Tween.new()

var target_scroll = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(scrollTween)
	get_v_scrollbar().rect_scale.y = 0
	Global.connect("card_added", self, "scroll_to_bottom")
	Global.connect("card_removed", self, "scroll_to_bottom")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_handle_actions()

# Bunch of functions to re-implement scrolling since we're being naughty with mixing control nodes and node2Ds
func _handle_actions():
	if Input.is_action_just_pressed("scroll_down"):
		animate_scroll(scroll_speed)
	elif Input.is_action_just_pressed("scroll_up"):
		animate_scroll(-scroll_speed)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_DOWN:
			animate_scroll(scroll_speed)
		elif event.button_index == BUTTON_WHEEL_UP:
			animate_scroll(-scroll_speed)

func _scroll_done():
	target_scroll = scroll_vertical

func scroll_to_bottom(_nothing=null):
	animate_scroll($DeckContainer.rect_size.y - scroll_vertical, 0.3)

func animate_scroll(scrollDiff, time=0.1):
	Global.set_selected_card(null)
	target_scroll += scrollDiff
	scrollTween.stop_all()
	scrollTween.interpolate_property(self, "scroll_vertical", scroll_vertical, target_scroll, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	scrollTween.interpolate_callback(self, time, "_scroll_done")
	scrollTween.start()
