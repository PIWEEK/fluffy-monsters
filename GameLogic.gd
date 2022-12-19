extends Node

@onready var events = get_node("/root/Events")

var delay = 1

var player1_ready = false
var player2_ready = false

func init_game():
	player1_ready = false
	player2_ready = false
	print("emit game_start")
	events.emit_signal("game_start")
	
func _on_player_ready(player):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		events.emit_signal("draw_start")
		
func _on_draw_end(player):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		events.emit_signal("play_start")
		
func _on_play_end(player, data):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		var turn_data = {}
		events.emit_signal("resolve_turn_start", turn_data)
		
func _on_resolve_turn_end(player):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		events.emit_signal("next_turn_start")
		
func _on_next_turn_end(player):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		var data = {}
		events.emit_signal("finish_game_start", data)
		
func _on_finish_game_end(player):
	await get_tree().create_timer(delay).timeout
	match player:
		1: player1_ready = true
		2: player2_ready = true
	
	if player1_ready and player2_ready:
		player1_ready = false
		player2_ready = false
		events.emit_signal("close_game")
		
func _ready():
	# events.connect("game_start", _on_game_start)
	events.connect("player_ready", _on_player_ready)
	# events.connect("draw_start", _on_draw_start)
	events.connect("draw_end", _on_draw_end)
	# events.connect("play_start", _on_play_start)
	events.connect("play_end", _on_play_end)
	# events.connect("resolve_turn_start", _on_resolve_turn_start)
	events.connect("resolve_turn_end", _on_resolve_turn_end)
	# events.connect("next_turn_start", _on_next_turn_start)
	events.connect("next_turn_end", _on_next_turn_end)
	# events.connect("finish_game_start", _on_finish_game_start)
	events.connect("finish_game_end", _on_finish_game_end)
	# events.connect("close_game", _on_close_game)
	init_game()
