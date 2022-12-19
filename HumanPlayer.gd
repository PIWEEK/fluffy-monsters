extends Panel

@onready var events = get_node("/root/Events")
@onready var btn_next = get_node("BtnNext")

var current_player = 1

# Store the current phase to send it to the main bus with a single button
var current_phase = ""

func _on_btn_next_pressed():
	btn_next.disabled = true
	
	match current_phase:
		"game_start":
			events.emit_signal("player_ready", current_player)
		
		"draw_start":
			events.emit_signal("draw_end", current_player)
			
		"play_start":
			var player_turn = {}
			events.emit_signal("play_end", current_player, player_turn)

		"resolve_turn_start":
			events.emit_signal("resolve_turn_end", current_player)

		"next_turn_start":
			events.emit_signal("next_turn_end", current_player)

		"finish_game_start":
			events.emit_signal("finish_game_end", current_player)

func _on_game_start():
	current_phase = "game_start"
	btn_next.disabled = false

func _on_draw_start():
	current_phase = "draw_start"
	btn_next.disabled = false

func _on_play_start():
	current_phase = "play_start"
	btn_next.disabled = false

func _on_resolve_turn_start(data):
	current_phase = "resolve_turn_start"
	btn_next.disabled = false

func _on_next_turn_start():
	current_phase = "next_turn_start"
	btn_next.disabled = false

func _on_finish_game_start(data):
	current_phase = "finish_game_start"
	btn_next.disabled = false

func _ready():
	print("ready human")
	btn_next.connect("pressed", _on_btn_next_pressed)
	events.connect("game_start", _on_game_start)
	# events.connect("player_ready", _on_player_ready)
	events.connect("draw_start", _on_draw_start)
	# events.connect("draw_end", _on_draw_end)
	events.connect("play_start", _on_play_start)
	# events.connect("play_end", _on_play_end)
	events.connect("resolve_turn_start", _on_resolve_turn_start)
	# events.connect("resolve_turn_end", _on_resolve_turn_end)
	events.connect("next_turn_start", _on_next_turn_start)
	# events.connect("next_turn_end", _on_next_turn_end)
	events.connect("finish_game_start", _on_finish_game_start)
	# events.connect("finish_game_end", _on_finish_game_end)
	# events.connect("close_game", _on_close_game)
