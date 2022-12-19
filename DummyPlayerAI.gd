extends Node

@onready var events = get_node("/root/Events")

# Delay before the AI emits its signals
var delay = 1

var current_player = 2

func _on_game_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("player_ready", current_player)

func _on_draw_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("draw_end", current_player)
	
func _on_play_start():
	await get_tree().create_timer(delay).timeout
	var player_turn = {}
	events.emit_signal("play_end", current_player, player_turn)
	
func _on_resolve_turn_start(data):
	await get_tree().create_timer(delay).timeout
	events.emit_signal("resolve_turn_end", current_player)

func _on_next_turn_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("next_turn_end", current_player)

func _on_finish_game_start(data):
	await get_tree().create_timer(delay).timeout
	events.emit_signal("finish_game_end", current_player)

func _on_close_game():
	pass

func _ready():
	print("ready dummy")
	events.connect("game_start", _on_game_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("play_start", _on_play_start)
	events.connect("resolve_turn_start", _on_resolve_turn_start)
	events.connect("next_turn_start", _on_next_turn_start)
	events.connect("finish_game_start", _on_finish_game_start)
	events.connect("close_game", _on_close_game)
	
