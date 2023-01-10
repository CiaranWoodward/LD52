extends CardType

func card_type():
	return Global.CardType.FIREWORK

func damage() -> float:
	if upgrade_level == 0:
		return 10.0
	else:
		return 20.0

func cheer() -> float:
	return 0.5

func stat_text() -> String:
	return "DMG: " + str(damage())

func spirit_cost() -> int:
	if upgrade_level == 0:
		return 2
	return 3

func max_upgrade_level() -> int:
	return 1
