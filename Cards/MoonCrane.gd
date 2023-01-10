extends CardType

func card_type():
	return Global.CardType.CRANE

func coin_cost():
	return 10

func spirit_cost():
	return 5

func damage() -> float:
	return 20.0

func stat_text() -> String:
	return "DMG: " + str(damage())
