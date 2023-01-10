extends CardType

func card_type():
	return Global.CardType.DRAGON

func coin_cost():
	return 20

func spirit_cost():
	return 8

func max_upgrade_level() -> int:
	return 1

func lifetime():
	if upgrade_level == 0:
		return 12.0
	else:
		return 20.0

func cheer() -> float:
	return 1.0

func stat_text() -> String:
	return str(lifetime()) + " seconds"
