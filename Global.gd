extends Node

signal unhovered_card
signal coin_changed(new_coin)
signal card_added(new_card)
signal card_removed(old_card)
signal change_selected_card(old, new)

var cheer = 0.1
var spirit = int(0)
var coin = int(10) setget set_coin
var portal_size = 1.0

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
	add_card_to_deck(CardType.FIRECRACKER)
	add_card_to_deck(CardType.LANTERN)
	add_card_to_deck(CardType.CAKE_STALL)
	add_card_to_deck(CardType.CRANE)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		set_selected_card(null)

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
	for card in deck:
		var p = card.get_parent()
		if is_instance_valid(p):
			p.remove_child(card)

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
