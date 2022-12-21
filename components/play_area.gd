extends Node2D

var play_card_scene = preload("res://components/play_card.tscn")

var state: GameState
var player_turn: Array[PlayerAction] = []
var current_player: int
var enemy_player: int

var locations

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

@onready var events = $"/root/Events"
@onready var db: DataBase = $"/root/DB"
@onready var next_turn_button = $NextTurnButton

# Called when the node enters the scene tree for the first time.
func _ready():
	
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	
	
	events.connect("begin_game_start", _on_begin_game_start)
	events.connect("play_start", _on_play_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("finish_turn_start", _on_finish_turn_start)
	
func _on_begin_game_start():	
	current_player = $PlayerController.current_player
	enemy_player = 2 if current_player == 1 else 1
			
	state = $GameLogic.state
	var state_locations: Array[GameLocation] = state.get_locations()
	
	$Location1.init2 (0, state_locations[0].location_id, state_locations[0].get_data(db))
	$Location2.init2 (1, state_locations[1].location_id, state_locations[1].get_data(db))
	$Location3.init2 (2, state_locations[2].location_id, state_locations[2].get_data(db))
	locations = {state_locations[0].location_id: $Location1, state_locations[1].location_id: $Location2, state_locations[2].location_id: $Location3}

func _on_play_start():
	# Allow the user to move cards
	player_turn = []
	next_turn_button.disabled = false
	
func _on_finish_turn_start():
	# Disallow the user to move cards
	next_turn_button.disabled = true
	var actions = state.turns[state.turn][enemy_player]
	var played_cards = []
	for action in actions:
		played_cards.append(play_enemy_action(action))
		
	reveal_enemy_cards(played_cards)
	events.emit_signal("finish_turn_end", current_player)
	
func play_enemy_action(action):
	var card = db.get_card(action.card_id)	
	var card_scene = play_card_scene.instantiate()
	card_scene.init(action.card_id, card)
	card_scene.show_back()
	locations[action.target_location_id].add_enemy_card(card_scene)
	return card_scene
	
func reveal_enemy_cards(cards):
	for card in cards:
			await get_tree().create_timer(1).timeout
			card.reveal()
			await get_tree().create_timer(1).timeout
			
			
	
	
func _on_draw_start():
	# Now it's deleting the whole hand and redrawing
	$Hand.remove_all_cards()
	
	var cards: Array[HandCard] = $PlayerController.get_hand_cards()
	
	for card in cards:
		var card_scene = play_card_scene.instantiate()
		card_scene.init(card.card_id, db.get_card(card.card_id))
		card_scene.energy = card.current_cost
		card_scene.power = card.current_power
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
	player_turn.push_back(PlayerAction.new(card.card_id, location.location_id))

func _on_next_turn_button_pressed():
	events.emit_signal("play_end", current_player, player_turn)
