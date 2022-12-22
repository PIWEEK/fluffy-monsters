extends Node

func execute(state: GameState, card: PlayedCard, player: int, location: GameLocation):
	var player_data = state.get_player_data(player)
	var hand: Array[HandCard] = player_data.hand
	hand[0].flags["discard"] = true
