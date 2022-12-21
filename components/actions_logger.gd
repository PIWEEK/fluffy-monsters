extends RichTextLabel

@onready var events: Events = $"/root/Events"
@onready var db: DataBase = $"/root/DB"
@onready var game_state_service: GameStateService = $"../GameLogic/GameStateService"

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
	var state: GameState = $"../GameLogic".state
	var hand_p1 = PackedStringArray()
	for card in state.player1_data.hand:
		hand_p1.append(card.card_id)
		
	var hand_p2 = PackedStringArray()
	for card in state.player2_data.hand:
		hand_p2.append(card.card_id)
		
	var deck_p1 = PackedStringArray()
	for card in state.player1_data.deck:
		deck_p1.append(card.name)
		
	var deck_p2 = PackedStringArray()
	for card in state.player2_data.deck:
		deck_p2.append(card.name)
	
	add_entry(1, "HAND P1:" + ",".join(hand_p1))
	add_entry(1, "DECK P1:" + ",".join(deck_p1))
	add_entry(2, "HAND P2:" + ",".join(hand_p2))
	add_entry(1, "DECK P2:" + ",".join(deck_p2))

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
	var state: GameState = $"../GameLogic".state
	var locations: Array[GameLocation] = state.get_locations()
	var location_str = ""
	
	for location in locations:
		var cards_p1 = PackedStringArray()
		for card in location.cards_p1:
			cards_p1.append(card.card_id)
		var p1_info = "%s [%s]" % [location.total_power_p1, ",".join(cards_p1)]
		
		var cards_p2 = PackedStringArray()
		for card in location.cards_p2:
			cards_p2.append(card.card_id)
		var p2_info = "%s [%s]" % [location.total_power_p2, ",".join(cards_p2)]
		location_str += "%s{P1:%s,P2:%s}, " % [ location.get_data(db).name, p1_info, p2_info]
	
	var hand_p1 = PackedStringArray()
	for card in state.player1_data.hand:
		hand_p1.append(card.card_id)
		
	var hand_p2 = PackedStringArray()
	for card in state.player2_data.hand:
		hand_p2.append(card.card_id)
		
	add_entry(0, "LOCATIONS:" + location_str)
	add_entry(1, "HAND P1:" + ",".join(hand_p1))
	add_entry(2, "HAND P2:" + ",".join(hand_p2))
	add_entry(0, "Finish Turn")

func _on_finish_turn_end(player: int):
	add_entry(player, "Finish Turn End")

func _on_finish_game_start():
	add_entry(0, "Finish Game")
	var winner = game_state_service.get_winner($"../GameLogic".state)
	if winner == 0:
		add_entry(0, "TIE!!")
	elif winner == 1:
		add_entry(0, "WINNER:" + $"../GameLogic".state.player1.player_name)
	else:
		add_entry(0, "WINNER:" + $"../GameLogic".state.player2.player_name)

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

func _on_clear_log_btn_pressed():
	clear()
