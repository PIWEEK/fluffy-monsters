extends Node

@onready var events = get_node("/root/Events")

var delay = 1

var player1_ready = false
var player2_ready = false

var state: GameState

func init_game():
	state = GameState.new()
	state.name = "GameState"
	state.set_phase(GameState.Phase.INIT)
	add_child(state)

	player1_ready = false
	player2_ready = false

	events.emit_signal("game_start")
	
func _on_player_join_start(player: Player):
	await get_tree().create_timer(delay).timeout
	
	if not player1_ready:
		player1_ready = true
		state.set_player(1, player)
		events.emit_signal("player_join_end", player.player_name, 1)
	else:
		player2_ready = true
		state.set_player(2, player)
		events.emit_signal("player_join_end", player.player_name, 2)

	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		events.emit_signal("begin_game_start")

func _on_begin_game_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.set_phase(GameState.Phase.INIT_TURN)
		events.emit_signal("begin_turn_start")

func _on_begin_turn_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.set_phase(GameState.Phase.DRAW)
		events.emit_signal("draw_start")

func _on_draw_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.set_phase(GameState.Phase.PLAY)
		events.emit_signal("play_start")
		
func _on_play_end(player: int, actions: Array[PlayerAction]):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.execute_actions(player, actions)
		state.set_phase(GameState.Phase.END_TURN)
		events.emit_signal("finish_turn_start")
		
func _on_finish_turn_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.set_phase(GameState.Phase.RESOLVE_GAME)
		events.emit_signal("finish_game_start")

func _on_finish_game_end(player: int):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		state.set_phase(GameState.Phase.END)
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
