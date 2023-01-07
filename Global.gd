extends Node

signal hovered_card_changed

var cheer = 0.1
var spirit = int(0)
var coin = int(0)
var portal_size = 1.0

var hovered_card = null

enum TransitionType {LINEAR = 0,SINE = 1,QUINT = 2,QUART = 3,QUAD = 4,EXPO = 5,ELASTIC = 6,CUBIC = 7,CIRC = 8,BOUNCE = 9,BACK = 10}
enum EaseType {IN = 0,OUT=1,IN_OUT=2,OUT_IN=3}

func hover_card(card):
	pass

func unhover_card(card):
	pass
