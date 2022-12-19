extends Node

class_name GameState

enum Phase {
	INIT,
	DRAW,
	INIT_TURN,
	PLAY,
	END_TURN,
	RESOLVE_TURN,
	RESOLVE_GAME,
	END
}

var turn: int
var phase: Phase

var left: GameLocation
var center: GameLocation
var right: GameLocation

var player1: Player
var player2: Player

var player1_data: PlayerGameData
var player2_data: PlayerGameData

func set_player(player_num: int, player: Player):
	pass

func set_phase(phase: Phase):
	pass

func execute_actions(player: int, actions: Array[PlayerAction]):
	pass
