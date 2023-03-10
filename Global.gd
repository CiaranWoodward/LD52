extends Node

signal unhovered_card
signal coin_changed(new_coin)
signal card_added(new_card)
signal card_removed(old_card)
signal change_selected_card(old, new)
signal moon_health_changed()
signal spirit_changed()

var spirit_cost = 1.0
var max_spirit = 10
var game_completed = false

var next_level_path = "res://Level/Level.tscn"
var cheer_left = 0.4
var cheer_right = 0.4
var spirit = int(0) setget set_spirit
var spirit_overflow = 0.0
var coin = int(10) setget set_coin
var portal_size = 1.0
var max_moon_health = 60.0
var moon_health = 60.0 setget set_moon_health

var hovered_card = null
var selected_card = null setget set_selected_card

var deck = []
var hud = null

enum CardType {DRAGON, FIREWORK, FIRECRACKER, LANTERN, LIGHT_STALL, CAKE_STALL, CRANE}

enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}

var card_scene

func _ready() -> void:
	card_scene = load("res://Cards/Card.tscn")
	randomize()
	add_card_to_deck(CardType.FIREWORK)
	add_card_to_deck(CardType.FIREWORK)
	add_card_to_deck(CardType.LANTERN)
	add_card_to_deck(CardType.CAKE_STALL)
	add_card_to_deck(CardType.CRANE)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		set_selected_card(null)
	spirit_overflow += delta * (cheer_left + cheer_right)
	if spirit_overflow > spirit_cost:
		spirit_overflow -= spirit_cost
		spirit += 1
		if spirit > max_spirit:
			spirit = max_spirit
		emit_signal("spirit_changed")

func add_card_to_deck(type):
	var newcard = card_scene.instance()
	newcard.set_type(type)
	deck.append(newcard)
	emit_signal("card_added", newcard)

func remove_card_from_deck(card):
	var idx = deck.find(card)
	if idx == -1:
		return
	deck.remove(idx)
	emit_signal("card_removed", card)
	card.queue_free()

func remove_deck_from_tree():
	set_selected_card(null)
	hovered_card = null
	for card in deck:
		var p = card.get_parent()
		card.reset_for_unseat()
		if is_instance_valid(p):
			p.remove_child(card)

func set_moon_health(newval):
	moon_health = float(newval)
	portal_size = moon_health/max_moon_health
	if portal_size > 1.0: portal_size = 1.0
	if portal_size < 0.0: portal_size = 0.0
	emit_signal("moon_health_changed")

func set_spirit(newval):
	spirit = newval
	emit_signal("spirit_changed")

func sort_deck():
	deck.sort_custom(self, "_card_compare")

func _card_compare(a, b):
	return a.get_type() < b.get_type()

func hover_card(card) -> bool:
	if !is_instance_valid(hovered_card):
		hovered_card = card
		return true
	return (hovered_card == card)

func unhover_card(card):
	if card == hovered_card:
		hovered_card = null
		emit_signal("unhovered_card")

func _release_hovercard_if_not_still_hovered():
	if is_instance_valid(hovered_card):
		if !hovered_card.mouse_over:
			unhover_card(hovered_card)

func set_selected_card(card):
	if card == selected_card:
		return
	if is_instance_valid(card):
		_release_hovercard_if_not_still_hovered()
		if !hover_card(card):
			return
	else:
		unhover_card(hovered_card)
	var old_card = selected_card
	selected_card = card
	if is_instance_valid(old_card):
		unhover_card(old_card)
		old_card.shrink_card()
	emit_signal("change_selected_card", old_card, card)

func unselect_card(card):
	if card == selected_card:
		set_selected_card(null)

func set_coin(newval):
	coin = newval
	emit_signal("coin_changed", newval)

static func remove_all_children(node, free=false):
	for n in node.get_children():
		node.remove_child(n)
		if free:
			n.queue_free()
