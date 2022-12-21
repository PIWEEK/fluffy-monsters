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

func save_play(state: GameState, player: int, actions: Array[PlayerAction]):
	var cur_turn = state.turn
	if cur_turn not in state.turns:
		state.turns[cur_turn] = {}
	state.turns[cur_turn][player] = actions

func resolve_action(state: GameState, player: int, action: PlayerAction):
	var location = location_service.get_location(state, action.target_location_id)
	var hand: Array[HandCard] = state.player1_data.hand if player == 1 else state.player2_data.hand
	var card: HandCard = hand_service.remove_card(hand, action.card_id)

	if player == 1:
		location.cards_p1.append(PlayedCard.new(card))
		location.total_power_p1 += card.current_power
	else:
		location.cards_p2.append(PlayedCard.new(card))
		location.total_power_p2 += card.current_power
	
	
func resolve_play(state: GameState):
	# TODO Resolve who goes first better
	var first_player = 1
	var second_player = 2
	var cur_turn = state.turn

	for action in state.turns[cur_turn][first_player]:
		resolve_action(state, first_player, action)

	for action in state.turns[cur_turn][second_player]:
		resolve_action(state, second_player, action)

func get_winner(state: GameState) -> int:
	var p1_wins = 0
	var p2_wins = 0
	var total_power_p1 = state.loc1.total_power_p1 + state.loc2.total_power_p1 + state.loc3.total_power_p1
	var total_power_p2 = state.loc1.total_power_p2 + state.loc2.total_power_p2 + state.loc3.total_power_p2
	
	if state.loc1.total_power_p1 > state.loc1.total_power_p2:
		p1_wins += 1
		
	if state.loc1.total_power_p2 > state.loc1.total_power_p1:
		p2_wins += 1
		
	if state.loc2.total_power_p1 > state.loc2.total_power_p2:
		p1_wins += 1
		
	if state.loc2.total_power_p2 > state.loc2.total_power_p1:
		p2_wins += 1
		
	if state.loc3.total_power_p1 > state.loc3.total_power_p2:
		p1_wins += 1
		
	if state.loc3.total_power_p2 > state.loc3.total_power_p1:
		p2_wins += 1
	
	var p1_won = p1_wins > p2_wins or (p1_wins == p2_wins and total_power_p1 > total_power_p2)
	var p2_won = p2_wins > p1_wins or (p1_wins == p2_wins and total_power_p2 > total_power_p1)
	
	return 1 if p1_won else 2 if p2_won else 0
	
func end_turn(state: GameState):
	pass

func check_end_game(state: GameState) -> bool:
	return state.turn == 6

func end_game(state: GameState):
	pass
