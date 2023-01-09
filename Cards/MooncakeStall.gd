extends CardType

func card_type():
	return Global.CardType.CAKE_STALL

func lifetime():
	return 8.0

func coin_period() -> float:
	return 1.0

func cheer() -> float:
	return 0.1
