extends Node
class_name CardType

var upgrade_level = 0

func card_type():
	assert(false)
	return Global.CardType.LANTERN

func coin_cost() -> int:
	return 2

func spirit_cost() -> int:
	return 2

func max_upgrade_level() -> int:
	return 0

func lifetime() -> float:
	return 0.0
