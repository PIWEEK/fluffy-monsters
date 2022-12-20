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

var left: GameLocation
var center: GameLocation
var right: GameLocation

var player1: Player
var player2: Player

var player1_data: PlayerGameData
var player2_data: PlayerGameData
