extends CardType

func card_type():
	return Global.CardType.FIRECRACKER

func lifetime():
	if upgrade_level == 0:
		return 10.0
	else:
		return 15.0

func stat_text() -> String:
	return str(lifetime()) + " seconds"

func coin_cost() -> int:
	return 8

func max_upgrade_level() -> int:
	return 1

func cheer() -> float:
	return 0.15
