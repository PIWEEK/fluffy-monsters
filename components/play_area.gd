extends Node2D

var play_card_scene = preload("res://components/play_card.tscn")
var card_zoom_scene = preload("res://components/card_zoom.tscn")

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

# Called when the node enters the scene tree for the first time.
func _ready():	
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	gui_events.connect("show_zoom_card", _on_show_zoom_card)
	events.connect("begin_turn_start", _on_begin_turn_start)
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("play_start", _on_play_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("finish_turn_start", _on_finish_turn_start)

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
	locations = {state_locations[0].location_id: $Location1, state_locations[1].location_id: $Location2, state_locations[2].location_id: $Location3}
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
	
func _on_play_start():
	# Allow the user to move cards
	player_turn = []
	player_played_cards = []
	next_turn_button.disabled = false
	
func _on_finish_turn_start():
	# Disallow the user to move cards
	next_turn_button.disabled = true
	await end_turn_show_cards()
	events.emit_signal("finish_turn_end", current_player)
	
func end_turn_show_cards():
	for card in player_played_cards:
		card.show_back()
		
	var played_cards = played_enemy_cards()
	await reveal_cards(played_cards)
	await reveal_cards(player_played_cards)
	
	
func played_enemy_cards():	
	var actions = state.turns[state.turn][enemy_player]
	var played_cards = []
	for action in actions:
		played_cards.append(create_enemy_card_from_action(action))
	return played_cards
	
	
func create_enemy_card_from_action(action):
	var card = db.get_card(action.card_id)	
	var card_scene = play_card_scene.instantiate()
	card_scene.init(action.card_id, card)
	card_scene.show_back()
	card_scene.belongs_to_player = false
	card_scene.draggable = false
	card_scene.played_location = action.target_location_id
	locations[action.target_location_id].add_enemy_card(card_scene)
	return card_scene
	
func reveal_cards(cards):
	for card in cards:
			await get_tree().create_timer(1).timeout
			card.reveal()			
			await get_tree().create_timer(1).timeout
			if card.belongs_to_player:
				locations[card.played_location].power_down += card.power
			else:
				locations[card.played_location].power_up += card.power
			locations[card.played_location].redraw_location()
			
func _on_draw_start():
	# Now it's deleting the whole hand and redrawing
	$Hand.remove_all_cards()
	
	var cards: Array[HandCard] = $PlayerController.get_hand_cards()
	
	for card in cards:
		var card_scene = play_card_scene.instantiate()
		card_scene.init(card.card_id, db.get_card(card.card_id))
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
	$Hand.remove_card(card)
	location.add_card(card)
	card.draggable = false
	card.belongs_to_player = true
	card.played_location = location.location_id
	player_played_cards.append(card)
	player_turn.push_back(PlayerAction.new(card.card_id, location.location_id))

func _on_show_zoom_card(card):
	var card_scene = card_zoom_scene.instantiate()
	card_scene.init(card)
	add_child(card_scene)

func _on_end_turn_button_pressed():
	events.emit_signal("play_end", current_player, player_turn)
