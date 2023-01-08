extends Node

signal unhovered_card

var cheer = 0.1
var spirit = int(0)
var coin = int(0)
var portal_size = 1.0

var hovered_card = null

var deck = []

enum CardType {DRAGON, FIREWORK, FIRECRACKER, LANTERN, LIGHT_STALL, CAKE_STALL, CRANE}

enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}

onready var card = load("res://Cards/Card.tscn")

func _ready() -> void:
	randomize()
	add_card_to_deck(CardType.FIREWORK)
	add_card_to_deck(CardType.FIREWORK)
	add_card_to_deck(CardType.LANTERN)
	add_card_to_deck(CardType.LANTERN)

func add_card_to_deck(type):
	var newcard = card.instance()
	newcard.set_type(type)
	deck.append(newcard)

func remove_deck_from_tree():
	for card in deck:
		var p = card.get_parent()
		if is_instance_valid(p):
			p.remove_child(card)

func hover_card(card) -> bool:
	if !is_instance_valid(hovered_card):
		hovered_card = card
		return true
	return (hovered_card == card)

func unhover_card(card):
	if card == hovered_card:
		hovered_card = null
		emit_signal("unhovered_card")

static func remove_all_children(node, free=false):
	for n in node.get_children():
		node.remove_child(n)
		if free:
			n.queue_free()
