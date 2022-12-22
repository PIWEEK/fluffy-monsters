extends OnCardPlay

func execute(state: GameState, card: PlayedCard, location: GameLocation, owner: int, played_card: PlayedCard, player: int, played_location: GameLocation):
	if owner == player and played_card.card_id != card.card_id:
		card.current_power += 1
