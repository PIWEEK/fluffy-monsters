extends Node

@onready var events = get_node("/root/Events")

@export var player_name: String
@export var player_avatar: Texture
@export var player_deck: String

var current_player: int

func join_game(name, avatar, deck):	
	self.player_name = name
	self.player_avatar = avatar
	self.player_deck = deck
	
	var player = Player.new()
	player.player_name = name
	player.avatar = player_avatar
	events.emit_signal("player_join_start", player, player_deck)
	
func _on_player_join_end(player_name: String, player: int):
	if self.player_name == player_name:
		current_player = player
	
func _on_begin_game_start():
	events.emit_signal("begin_game_end", current_player)

func draw_finished():
	events.emit_signal("draw_end", current_player)

func _on_finish_turn_start():
	events.emit_signal("finish_turn_end", current_player)

func _on_begin_turn_start():
	events.emit_signal("begin_turn_end", current_player)

func _on_finish_game_start():
	events.emit_signal("finish_game_end", current_player)

func _ready():
	#events.connect("game_start", _on_game_start)
	events.connect("player_join_end", _on_player_join_end)
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("begin_turn_start", _on_begin_turn_start)
	#events.connect("draw_start", _on_draw_start)
	#events.connect("play_start", _on_play_start)
	events.connect("finish_turn_start", _on_finish_turn_start)
	events.connect("finish_game_start", _on_finish_game_start)

func get_hand_cards() -> Array[HandCard]:
	var state: GameState = $"../GameLogic".state
	if current_player == 1:
		return state.player1_data.hand
	else:
		return state.player2_data.hand
