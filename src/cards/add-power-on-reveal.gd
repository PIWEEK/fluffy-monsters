extends OnSelfReveal

## Adds + 2 power on reveal
func execute(state: GameState, card: PlayedCard, player: int, location: GameLocation):
	var others = location.get_cards(player)
	card.current_power += len(others) * 2
	
