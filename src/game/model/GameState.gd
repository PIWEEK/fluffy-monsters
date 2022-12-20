extends Object

class_name GameState

enum Phase {
	JOINING,
	START_GAME,
	START_TURN,
	DRAW,
	PLAY,
	END_TURN,
	END_GAME,
	END
}

var turn: int
var phase: Phase

var loc1: GameLocation
var loc2: GameLocation
var loc3: GameLocation

var player1: Player
var player2: Player

var player1_data: PlayerGameData
var player2_data: PlayerGameData

# Store the turns
var turns: Dictionary

func _init():
	self.turns = {}

func get_player_data(player_num: int) -> PlayerGameData:
	if player_num == 1:
		return player1_data
	else:
		return player2_data

func get_locations() -> Array[GameLocation]:
	return [loc1, loc2, loc3]
