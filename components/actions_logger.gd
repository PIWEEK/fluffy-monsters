extends RichTextLabel

@onready var events: Events = $"/root/Events"
@onready var db: DataBase = $"/root/DB"

@export_color_no_alpha var color_p1: Color
@export_color_no_alpha var color_p2: Color

func add_entry(player, msg):
	var color = ""
	var player_name = ""
	
	if player == 1: 
		color = color_p1.to_html()
		player_name = $"../GameLogic".state.player1.player_name
	elif player == 2: 
		color = color_p2.to_html()
		player_name = $"../GameLogic".state.player2.player_name
	else:
		color = "white"
		player_name = "GAME"
		
	append_text("[b][color=%s]%s[/color][/b] %s\n" % [color, player_name, msg])

func _on_game_start():
	add_entry(0, "Start")

func _on_player_join_start(player: Player, deck_id: String):
	add_entry(0, "Join %s, deck %s" % [player.player_name, deck_id])

func _on_player_join_end(player: int):
	add_entry(player, "Joined")

func _on_begin_game_start():
	add_entry(0, "Begin Game")

func _on_begin_game_end(player: int):
	add_entry(player, "Begin Game End")

func _on_begin_turn_start():
	add_entry(0, "Begin Turn")

func _on_begin_turn_end(player: int):
	add_entry(player, "Begin Turn End")

func _on_draw_start():
	add_entry(0, "Draw")

func _on_draw_end(player: int):
	add_entry(player, "Draw End")

func _on_play_start():
	add_entry(0, "Play")

func _on_play_end(player: int, actions: Array[PlayerAction]):
	var play_string = ""
	for action in actions:
		var card = db.get_card(action.card_id)
		var location = db.get_location(action.target_location_id)
		play_string += "(%s in %s), " % [card.card_name, location.location_name]
	add_entry(player, "PLAY END %s" % play_string)

func _on_finish_turn_start():
	add_entry(0, "Finish Turn")

func _on_finish_turn_end(player: int):
	add_entry(player, "Finish Turn End")

func _on_finish_game_start():
	add_entry(0, "Finish Game")

func _on_finish_game_end(player: int):
	add_entry(player, "Finish Game End")

func _on_game_end():
	add_entry(0, "END")

func _ready():
	events.connect("game_start", _on_game_start)
	events.connect("player_join_start", _on_player_join_start)
	events.connect("player_join_end", _on_player_join_end)
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("begin_game_end", _on_begin_game_end)
	events.connect("begin_turn_start", _on_begin_turn_start)
	events.connect("begin_turn_end", _on_begin_turn_end)
	events.connect("draw_start", _on_draw_start)
	events.connect("draw_end", _on_draw_end)
	events.connect("play_start", _on_play_start)
	events.connect("play_end", _on_play_end)
	events.connect("finish_turn_start", _on_finish_turn_start)
	events.connect("finish_turn_end", _on_finish_turn_end)
	events.connect("finish_game_start", _on_finish_game_start)
	events.connect("finish_game_end", _on_finish_game_end)
	events.connect("game_end", _on_game_end)

