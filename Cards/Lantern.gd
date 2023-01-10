extends CardType

func card_type():
	return Global.CardType.LANTERN

func damage() -> float:
	if upgrade_level == 0:
		return 20.0
	return 30.0

func cheer() -> float:
	return 0.1

func stat_text() -> String:
	return "DMG: " + str(damage())

func spirit_cost() -> int:
	return 2

func max_upgrade_level() -> int:
	return 1
