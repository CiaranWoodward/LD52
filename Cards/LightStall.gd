extends CardType

func card_type():
	return Global.CardType.LIGHT_STALL

func lifetime():
	if upgrade_level == 0:
		return 8.0
	return 16.0

func cheer() -> float:
	return 0.8

func stat_text() -> String:
	return "8 joy, " + str(lifetime()) + " seconds"

func spirit_cost() -> int:
	if upgrade_level == 0:
		return 2
	return 3

func max_upgrade_level() -> int:
	return 1
