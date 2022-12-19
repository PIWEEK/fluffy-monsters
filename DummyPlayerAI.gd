extends Node

@onready var events = get_node("/root/Events")

# Delay before the AI emits its signals
var delay = 1

@export var player_name: String
@export var player_avatar: Texture

var current_player

func _on_game_start():
	await get_tree().create_timer(delay).timeout
	var player = Player.new()
	player.player_name = player_name
	player.avatar = player_avatar
	events.emit_signal("player_join_start", player)

func _on_player_join_end(player_name: String, player: int):
	if self.player_name == player_name:
		current_player = player

func _on_begin_game_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("begin_game_end", current_player)

func _on_begin_turn_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("begin_turn_end", current_player)

func _on_draw_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("draw_end", current_player)
	
func _on_play_start():
	await get_tree().create_timer(delay).timeout
	var player_turn: Array[PlayerAction] = []
	events.emit_signal("play_end", current_player, player_turn)
	
func _on_finish_turn_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("finish_turn_end", current_player)

func _on_finish_game_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("finish_game_end", current_player)

func _ready():
	events.connect("game_start", _on_game_start)
	events.connect("player_join_end", _on_player_join_end)
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("begin_turn_start", _on_begin_turn_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("play_start", _on_play_start)
	events.connect("finish_turn_start", _on_finish_turn_start)
	events.connect("finish_game_start", _on_finish_game_start)
