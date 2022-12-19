extends RichTextLabel

@onready var events = get_node("/root/Events")

func add_entry(player, msg):
	var color = ""
	var player_name = ""
	
	if player == 1: 
		color = "blue"
		player_name = "Player 1"
	elif player == 2: 
		color = "red"
		player_name = "Player 2"
	else:
		color = "white"
		player_name = "GAME"
		
	append_text("[b][color=%s]%s[/color][/b] %s\n" % [color, player_name, msg])

func _on_game_start():
	add_entry(0, "START")
	
func _on_player_ready(player):
	add_entry(player, "Player Ready")

func _on_draw_start():
	add_entry(0, "Draw Start")

func _on_draw_end(player):
	add_entry(player, "Draw End")

func _on_play_start():
	add_entry(0, "Play Start")

func _on_play_end(player, data):
	add_entry(player, "Play End")

func _on_resolve_turn_start(data):
	add_entry(0, "Resolve Turn Start")

func _on_resolve_turn_end(player):
	add_entry(player, "Resolve Turn End")

func _on_next_turn_start():
	add_entry(0, "Next Turn Start")

func _on_next_turn_end(player):
	add_entry(player, "Next Turn End")

func _on_finish_game_start(data):
	add_entry(0, "Finish Game Start")

func _on_finish_game_end(player):
	add_entry(player, "Finish Game End")

func _on_close_game():
	add_entry(0, "END")

func _ready():
	print("ready logs")
	events.connect("game_start", _on_game_start)
	events.connect("player_ready", _on_player_ready)
	events.connect("draw_start", _on_draw_start)
	events.connect("draw_end", _on_draw_end)
	events.connect("play_start", _on_play_start)
	events.connect("play_end", _on_play_end)
	events.connect("resolve_turn_start", _on_resolve_turn_start)
	events.connect("resolve_turn_end", _on_resolve_turn_end)
	events.connect("next_turn_start", _on_next_turn_start)
	events.connect("next_turn_end", _on_next_turn_end)
	events.connect("finish_game_start", _on_finish_game_start)
	events.connect("finish_game_end", _on_finish_game_end)
	events.connect("close_game", _on_close_game)
