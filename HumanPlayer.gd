extends Panel

@onready var events = get_node("/root/Events")
@onready var btn_next = get_node("BtnNext")

@export var player_name: String
@export var player_avatar: Texture

# Store the current phase to send it to the main bus with a single button
var current_phase: String
var current_player: int

func _on_btn_next_pressed():
	btn_next.disabled = true
	
	match current_phase:
		"game_start":
			var player = Player.new()
			player.player_name = player_name
			player.avatar = player_avatar
			events.emit_signal("player_join_start", player)
		
		"begin_game_start":
			events.emit_signal("begin_game_end", current_player)
			
		"draw_start":
			events.emit_signal("draw_end", current_player)
			
		"play_start":
			var player_turn: Array[PlayerAction] = []
			events.emit_signal("play_end", current_player, player_turn)

		"begin_turn_start":
			events.emit_signal("begin_turn_end", current_player)

		"finish_turn_start":
			events.emit_signal("finish_turn_end", current_player)

		"finish_game_start":
			events.emit_signal("finish_game_end", current_player)

func _on_game_start():
	current_phase = "game_start"
	btn_next.disabled = false
	
func _on_player_join_end(player_name: String, player: int):
	if self.player_name == player_name:
		current_player = player
	
func _on_begin_game_start():
	current_phase = "begin_game_start"
	btn_next.disabled = false

func _on_draw_start():
	current_phase = "draw_start"
	btn_next.disabled = false

func _on_play_start():
	current_phase = "play_start"
	btn_next.disabled = false

func _on_begin_turn_start():
	current_phase = "begin_turn_start"
	btn_next.disabled = false

func _on_finish_turn_start():
	current_phase = "finish_turn_start"
	btn_next.disabled = false

func _on_finish_game_start():
	current_phase = "finish_game_start"
	btn_next.disabled = false

func _ready():
	btn_next.connect("pressed", _on_btn_next_pressed)
	
	events.connect("game_start", _on_game_start)
	events.connect("player_join_end", _on_player_join_end)
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("begin_turn_start", _on_begin_turn_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("play_start", _on_play_start)
	events.connect("finish_turn_start", _on_finish_turn_start)
	events.connect("finish_game_start", _on_finish_game_start)

