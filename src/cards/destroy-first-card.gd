extends OnSelfReveal

func execute(state: GameState, card: PlayedCard, player: int, location: GameLocation):
	var cards = location.get_opponent_cards(player)
	
	# Tries to destroy the first card
	for i in len(cards):
		if not cards[i].flags.has("destroy"):
			cards[i].flags["destroy"] = true
			break
