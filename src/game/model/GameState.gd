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
	
func copy() -> GameState:
	var result = GameState.new()
	result.turn = turn
	result.phase = phase
	result.loc1 = loc1.copy()
	result.loc2 = loc2.copy()
	result.loc3 = loc3.copy()
	result.player1 = player1.copy()
	result.player2 = player2.copy()
	result.player1_data = player1_data.copy()
	result.player2_data = player2_data.copy()
	
	result.turns = Dictionary()
	for t in turns.keys():
		result.turns[t] = Dictionary()
		for p in turns[t].keys():
			result.turns[t][p] = []
			for i in range(0, len(result.turns[t][p])):
				result.turns[t][p][i].append(turns[t][p][i].copy())

	return result

func get_player_data(player_num: int) -> PlayerGameData:
	if player_num == 1:
		return player1_data
	else:
		return player2_data

func get_locations() -> Array[GameLocation]:
	return [loc1, loc2, loc3]
