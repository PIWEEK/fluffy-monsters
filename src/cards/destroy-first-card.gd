extends Node

func execute(state: GameState, card: PlayedCard, player: int, location: GameLocation):
	var cards = location.get_opponent_cards(player)
	cards[0].flags["destroy"] = true
