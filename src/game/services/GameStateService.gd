extends Node

class_name GameStateService

@onready var deck_service: DeckService = $"../DeckService"
@onready var hand_service: HandService = $"../HandService"
@onready var location_service: LocationService = $"../LocationService"

func init_player(state: GameState, player_num: int, player: Player, deck_id: String):
	var deck = deck_service.retrieve_deck(deck_id)
	if player_num == 1:
		state.player1 = player
		state.player1_data = PlayerGameData.new(player_num, deck)
	else:
		state.player2 = player
		state.player2_data = PlayerGameData.new(player_num, deck)

func init_game(state: GameState):
	state.turn = 0
	
	# Initialize players decks
	deck_service.shuffle(state.player1_data.deck)
	deck_service.shuffle(state.player2_data.deck)
	
	# Draw 3 initial cards
	hand_service.draw(state.player1_data.deck, state.player1_data.hand, 3)
	hand_service.draw(state.player2_data.deck, state.player2_data.hand, 3)
	
	var locations = location_service.select_random_locations()
	state.loc1 = GameLocation.new(locations[0])
	state.loc2 = GameLocation.new(locations[1])
	state.loc3 = GameLocation.new(locations[2])

func start_turn(state: GameState):
	state.turn += 1
	state.player1_data.energy = state.turn
	state.player2_data.energy = state.turn

func draw(state: GameState):
	if state.player1_data.hand.size() <= 7:
		hand_service.draw(state.player1_data.deck, state.player1_data.hand)
	
	if state.player2_data.hand.size() <= 7:
		hand_service.draw(state.player2_data.deck, state.player2_data.hand)

func play(state: GameState, player: int, actions: Array[PlayerAction]):
	pass

func end_turn(state: GameState):
	pass

func check_end_game(state: GameState) -> bool:
	return state.turn == 6

func end_game(state: GameState):
	pass
