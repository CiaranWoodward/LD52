extends Node
class_name CardType

var upgrade_level = 0

func card_type():
	assert(false)
	return Global.CardType.LANTERN

func coin_cost():
	return 2

func spirit_cost():
	return 2

func max_upgrade_level():
	return 0
