extends Node

@onready var events = get_node("/root/Events")

@onready var game_state_service: GameStateService = $GameStateService
@onready var deck_service: DeckService = $DeckService
@onready var hand_service: HandService = $HandService
@onready var card_executor_service: CardExecutorService = $CardExecutorService

@export var delay = 0

var player1_ready = false
var player2_ready = false

var state: GameState

func init_game():
	state = GameState.new()
	state.phase = GameState.Phase.JOINING

	player1_ready = false
	player2_ready = false

	events.emit_signal("game_start")
	
func _on_player_join_start(player: Player, deck_id: String):
	await get_tree().create_timer(delay).timeout
	
	if not player1_ready:
		player1_ready = true
		game_state_service.init_player(state, 1, player, deck_id)
		events.emit_signal("player_join_end", player.player_name, 1)
	else:
		player2_ready = true
		game_state_service.init_player(state, 2, player, deck_id)
		events.emit_signal("player_join_end", player.player_name, 2)

	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.phase = GameState.Phase.START_GAME
		game_state_service.init_game(state)
		events.emit_signal("begin_game_start")

func _on_begin_game_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false

		state.phase = GameState.Phase.START_TURN
		game_state_service.start_turn(state)
		events.emit_signal("begin_turn_start")

func _on_begin_turn_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.phase = GameState.Phase.DRAW
		game_state_service.draw(state)
		events.emit_signal("draw_start")

func _on_draw_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.phase = GameState.Phase.PLAY
		events.emit_signal("play_start")
		
func _on_play_end(player: int, actions: Array[PlayerAction]):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	game_state_service.save_play(state, player, actions)
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false

		state.phase = GameState.Phase.END_TURN
		game_state_service.resolve_play(state)
		events.emit_signal("finish_turn_start")
		
func _on_finish_turn_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
	
		game_state_service.end_turn(state)
		if game_state_service.check_end_game(state):
			state.phase = GameState.Phase.END_GAME
			game_state_service.end_game(state)
			events.emit_signal("finish_game_start")
		else:
			state.phase = GameState.Phase.START_TURN
			game_state_service.start_turn(state)
			events.emit_signal("begin_turn_start")

func _on_finish_game_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
	
		state.phase = GameState.Phase.END
		events.emit_signal("game_end")
		
func _ready():
	events.connect("player_join_start", _on_player_join_start)
	events.connect("begin_game_end", _on_begin_game_end)
	events.connect("begin_turn_end", _on_begin_turn_end)
	events.connect("draw_end", _on_draw_end)
	events.connect("play_end", _on_play_end)
	events.connect("finish_turn_end", _on_finish_turn_end)
	events.connect("finish_game_end", _on_finish_game_end)

	init_game()
