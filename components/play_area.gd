extends Node2D

var play_card_scene = preload("res://components/play_card.tscn")
var card_zoom_scene = preload("res://components/card_zoom.tscn")
var location_zoom_scene = preload("res://components/location_zoom.tscn")
var end_game_scene = preload("res://components/end_game.tscn")

var sound_place_card = preload("res://resources/sound/flipcard.wav")
var sound_flip_card = preload("res://resources/sound/flip.wav")
var sound_turn = preload("res://resources/sound/turn.wav")
var sound_disappear = preload("res://resources/sound/disappear.wav")

var song_victory = preload("res://resources/sound/Club Seamus.mp3")


var state: GameState
var player_turn: Array[PlayerAction] = []
var current_player: int
var enemy_player: int

var locations
var player_played_cards = []

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

@onready var events = $"/root/Events"
@onready var db: DataBase = $"/root/DB"
@onready var next_turn_button = $Actions/EndTurnButton

@onready var rounds_label = $Actions/EndTurnButton/Rounds
@onready var energy_label = $Actions/EndTurnButton/Energy/Label

@onready var game_state_service: GameStateService = $GameLogic/GameStateService

# Called when the node enters the scene tree for the first time.
func _ready():	
	gui_state.cards_hand = []
	gui_state.cards_location = [[], [], []]
	gui_state.cards_location_enemy = [[], [], []]
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	gui_events.connect("show_zoom_card", _on_show_zoom_card)
	gui_events.connect("show_zoom_location", _on_show_zoom_location)
	events.connect("begin_turn_start", _on_begin_turn_start)
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("play_start", _on_play_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("resolve_turn_start", _on_resolve_turn_start)
	events.connect("finish_game_start", _on_finish_game_start)	
	if gui_state.sound_on:
		$Music.play()
	

	$PlayerController.join_game(gui_state.player_name, db.get_avatar(gui_state.player_avatar).image, gui_state.player_deck)

func _on_begin_game_start():	
	$Header/Player1/Label.text = $GameLogic.state.player1.player_name
	$Header/Player1/Avatar.texture = $GameLogic.state.player1.avatar
	$Header/Player2/Label.text = $GameLogic.state.player2.player_name
	$Header/Player2/Avatar.texture = $GameLogic.state.player2.avatar

	current_player = $PlayerController.current_player
	enemy_player = 2 if current_player == 1 else 1
			
	state = $GameLogic.state
	var state_locations: Array[GameLocation] = state.get_locations()
	
	$Location1.init2 (0, state_locations[0].location_id, state_locations[0].get_data(db))
	$Location2.init2 (1, state_locations[1].location_id, state_locations[1].get_data(db))
	$Location3.init2 (2, state_locations[2].location_id, state_locations[2].get_data(db))
	locations = {\
		state_locations[0].location_id: $Location1,\
		state_locations[1].location_id: $Location2,\
		state_locations[2].location_id: $Location3}
	$Location1.redraw_location()
	$Location2.redraw_location()
	$Location3.redraw_location()
	
	energy_label.text = str(1)
	rounds_label.text = "Round 1/6"

func _on_begin_turn_start():
	var state: GameState = $GameLogic.state
	var player: PlayerGameData = state.player1_data if current_player == 1 else state.player2_data
	energy_label.text = str(state.player1_data.energy)
	rounds_label.text = "Round %s/6" % [state.turn]
	gui_state.current_energy = state.player1_data.energy
	
func _on_play_start():
	# Allow the user to move cards
	player_turn = []
	player_played_cards = []
	next_turn_button.disabled = false
	
func _on_resolve_turn_start():
	# Disallow the user to move cards
	next_turn_button.disabled = true
	await end_turn_show_cards()
	events.emit_signal("resolve_turn_end", current_player)
	
func end_turn_show_cards():
	for card in player_played_cards:
		card.show_back()
		
	var enemy_cards = played_enemy_cards()
	await reveal_cards(player_played_cards, enemy_cards)
	
func played_enemy_cards():	
	var actions = state.turns[state.turn][enemy_player]
	var played_cards = []
	for action in actions:
		played_cards.append(create_enemy_card_from_action(action))
	return played_cards
	
	
func create_enemy_card_from_action(action):
	var card = db.get_card(action.card_id)	
	var card_scene = play_card_scene.instantiate()
	var player = 2 if current_player == 1 else 1
	card_scene.init(player, action.card_id, card)
	card_scene.show_back()
	card_scene.belongs_to_player = false
	card_scene.draggable = false
	card_scene.played_location = action.target_location_id
	card_scene.set_played_mode(true)
	locations[action.target_location_id].add_enemy_card(card_scene)
	return card_scene
	
func reveal_cards(player_cards, enemy_cards):
	var state = $GameLogic.state.copy()
	await get_tree().create_timer(1).timeout
	
	var current_winner = game_state_service.get_winner(state)
	var cards
	if current_winner == current_player or (current_winner == 0 and current_player == 1):
		cards = player_cards + enemy_cards
	else:
		cards = enemy_cards + player_cards

	for card in cards:
		play_sound(sound_flip_card)
	
		await card.reveal()
		var location = locations[card.played_location]
		game_state_service.resolve_action(state, card.player, PlayerAction.new(card.card_id, location.location_id))
		
		for loc in state.get_locations():
			for c1 in loc.cards_p1:
				var card_node = locations[loc.location_id].get_node("1-" + c1.card_id)
				if card_node:
					card_node.set_power(c1.current_power)
					if c1.flags.has("destroy"):
						await card_dissapear(card_node)
						locations[loc.location_id].remove_card(card_node)

			for c2 in loc.cards_p2:
				var card_node = locations[loc.location_id].get_node("2-" + c2.card_id)
				if card_node:
					card_node.set_power(c2.current_power)
					if c2.flags.has("destroy"):
						await card_dissapear(card_node)
						locations[loc.location_id].remove_card(card_node)

			locations[loc.location_id].power_down = loc.get_total_power(1) if current_player == 1 else loc.get_total_power(2)
			locations[loc.location_id].power_up = loc.get_total_power(2) if current_player == 1 else loc.get_total_power(1)
			locations[loc.location_id].redraw_location()
			locations[loc.location_id].redraw_location()

		for hand_card in state.get_player_data(current_player).hand:
			if hand_card.flags.has("discard"):
				var card_node = $Hand.get_node("%s-%s" % [current_player, hand_card.card_id])
				if card_node:
					await card_dissapear(card_node)
					$Hand.remove_card(card_node)
		
		await get_tree().create_timer(0.5).timeout

func card_dissapear(card_node):
	play_sound(sound_disappear)
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(card_node, "scale", Vector2(3, 3), 0.8)
	
	var tween2: Tween = get_tree().create_tween()
	tween2.set_ease(Tween.EASE_IN_OUT)
	tween2.set_trans(Tween.TRANS_QUAD)
	tween2.tween_property(card_node, "modulate:a", 0, 0.8)
	
	await tween.finished

func _on_draw_start():
	# Now it's deleting the whole hand and redrawing
	$Hand.remove_all_cards()
	
	var cards: Array[HandCard] = $PlayerController.get_hand_cards()
	
	for card in cards:
		var card_scene = play_card_scene.instantiate()
		card_scene.init(current_player, card.card_id, db.get_card(card.card_id))
		card_scene.energy = card.current_cost
		card_scene.power = card.current_power
		card_scene.draggable = true
		$Hand.add_card(card_scene)
		
	$PlayerController.draw_finished()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_stop_drag_card(card):	
	if gui_state.dragging_location != null:
		play_card(card, gui_state.dragging_location)

func play_card(card, location):
	play_sound(sound_place_card)
		
	gui_state.current_energy -= card.energy
	$Hand.remove_card(card)
	location.add_card(card)
	card.set_played_mode(true)
	card.player = current_player
	card.draggable = false
	card.belongs_to_player = true
	card.played_location = location.location_id
	player_played_cards.append(card)
	player_turn.push_back(PlayerAction.new(card.card_id, location.location_id))	
	energy_label.text = str(gui_state.current_energy)

func _on_show_zoom_card(card):
	var card_scene = card_zoom_scene.instantiate()
	card_scene.init(card)
	add_child(card_scene)
	
func _on_show_zoom_location(location):
	var location_scene = location_zoom_scene.instantiate()
	location_scene.init(location)
	add_child(location_scene)
	

func _on_end_turn_button_pressed():
	play_sound(sound_turn)
		
	events.emit_signal("play_end", current_player, player_turn)
	
func _on_finish_game_start():
	var scene = end_game_scene.instantiate()
	var winner = $GameLogic/GameStateService.get_winner(state)
	scene.init(winner == current_player, current_player)
	add_child(scene)
	if gui_state.sound_on:
		$Music.stream = song_victory
		$Music.play()
	
	
func _on_retreat_button_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	
func play_sound(sound):
	if gui_state.sound_on:
		$Audio.stream = sound
		$Audio.play()
		
