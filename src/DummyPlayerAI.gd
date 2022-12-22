extends Node

@onready var events = get_node("/root/Events")

# Delay before the AI emits its signals
@export var delay = 0
@export var player_name: String
@export var player_avatar: Texture
@export var player_deck: String

var current_player

### MAIN LOGIC FOR THE BOT
###  - Selects all the cards that can play in a greedy fashion
###  - Plays them in the first location with available slots
func play_turn() -> Array[PlayerAction]:
	var player_turn: Array[PlayerAction] = []
	
	var state: GameState = $"../GameLogic".state
	var player_data: PlayerGameData = state.get_player_data(current_player)
	var locations: Array[GameLocation] = state.get_locations()
	
	var played_cards = Dictionary()
	var current_energy = player_data.energy
	for card in player_data.hand:
		if card.current_cost <= current_energy:
			for loc in locations:
				if loc.location_id not in played_cards:
					played_cards[loc.location_id] = 0
				if 	(current_player == 1 and (loc.cards_p1.size() + played_cards[loc.location_id]) < 4) or \
					(current_player == 2 and (loc.cards_p2.size() + played_cards[loc.location_id]) < 4):
					
					played_cards[loc.location_id] += 1
					player_turn.push_back(PlayerAction.new(card.card_id, loc.location_id))
					current_energy -= card.current_cost
					break
	return player_turn

func _on_game_start():
	await get_tree().create_timer(delay).timeout
	var player = Player.new()
	player.player_name = player_name
	player.avatar = player_avatar
	events.emit_signal("player_join_start", player, player_deck)

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
	events.emit_signal("play_end", current_player, play_turn())

func _on_resolve_turn_start():
	await get_tree().create_timer(delay).timeout
	events.emit_signal("resolve_turn_end", current_player)

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
	events.connect("resolve_turn_start", _on_resolve_turn_start)
	events.connect("finish_turn_start", _on_finish_turn_start)
	events.connect("finish_game_start", _on_finish_game_start)
