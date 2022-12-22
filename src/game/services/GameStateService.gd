extends Node

class_name GameStateService

@onready var deck_service: DeckService = $"../DeckService"
@onready var hand_service: HandService = $"../HandService"
@onready var location_service: LocationService = $"../LocationService"
@onready var card_executor_service: CardExecutorService = $"../CardExecutorService"

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
	var hand: Array[HandCard] = state.get_player_data(player).hand
	var card: HandCard = hand_service.remove_card(hand, action.card_id)

	var played_card = PlayedCard.new(card)
	card_executor_service.before_reveal(state, played_card, player, location)
	if player == 1:
		location.cards_p1.append(played_card)
	else:
		location.cards_p2.append(played_card)
		
	card_executor_service.after_reveal(state, played_card, player, location)

func resolve_play(state: GameState):
	var winner = get_winner(state)
	var first_player = 1 if winner == 1 or winner == 0 else 2
	var second_player = 2 if winner == 1 or winner == 0 else 1
	var cur_turn = state.turn

	for action in state.turns[cur_turn][first_player]:
		resolve_action(state, first_player, action)

	for action in state.turns[cur_turn][second_player]:
		resolve_action(state, second_player, action)

func get_winner(state: GameState) -> int:
	var p1_wins = 0
	var p2_wins = 0
	var l1_p1_pow = state.loc1.get_total_power(1)
	var l2_p1_pow = state.loc2.get_total_power(1)
	var l3_p1_pow = state.loc3.get_total_power(1)
	var l1_p2_pow = state.loc1.get_total_power(2)
	var l2_p2_pow = state.loc2.get_total_power(2)
	var l3_p2_pow = state.loc3.get_total_power(2)
	
	var total_power_p1 = l1_p1_pow + l2_p1_pow + l3_p1_pow
	var total_power_p2 = l1_p2_pow + l2_p2_pow + l3_p2_pow
	
	if l1_p1_pow > l1_p2_pow:
		p1_wins += 1
		
	if l1_p2_pow > l1_p1_pow:
		p2_wins += 1
	
	if l2_p1_pow > l2_p2_pow:
		p1_wins += 1
		
	if l2_p2_pow > l2_p1_pow:
		p2_wins += 1
	
	if l3_p1_pow > l3_p2_pow:
		p1_wins += 1
		
	if l3_p2_pow > l3_p1_pow:
		p2_wins += 1
	
	var p1_won = p1_wins > p2_wins or (p1_wins == p2_wins and total_power_p1 > total_power_p2)
	var p2_won = p2_wins > p1_wins or (p1_wins == p2_wins and total_power_p2 > total_power_p1)
	
	return 1 if p1_won else 2 if p2_won else 0
	
func end_turn(state: GameState):
	# Remove discard from hand
	if len(state.player1_data.hand) > 0:
		for i in range(len(state.player1_data.hand)-1, -1, -1):
			if state.player1_data.hand[i].flags.has("discard"):
				state.player1_data.hand.remove_at(i)
				card_executor_service.after_discard(state, state.player1_data.hand[i], 1)
	
	if len(state.player2_data.hand):
		for i in range(len(state.player2_data.hand)-1, -1, -1):
			if state.player2_data.hand[i].flags.has("discard"):
				state.player2_data.hand.remove_at(i)
				card_executor_service.after_discard(state, state.player2_data.hand[i], 2)
	
	# Remove destroyed cards
	for loc in state.get_locations():
		for i in range(len(loc.cards_p1)-1, 0, -1):
			if loc.cards_p1[i].flags.has("destroy"):
				loc.cards_p1.remove_at(i)
				card_executor_service.after_destroy(state, loc.cards_p1[i], 1, loc)
		
		for i in range(len(loc.cards_p2)-1, 0, -1):
			if loc.cards_p2[i].flags.has("destroy"):
				loc.cards_p2.remove_at(i)
				card_executor_service.after_destroy(state, loc.cards_p1[i], 1, loc)

func check_end_game(state: GameState) -> bool:
	return state.turn == 6

func end_game(state: GameState):
	pass
