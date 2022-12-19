extends Node

class_name PlayerAction

enum Type {
	PLAY_CARD,
	MOVE_CARD
}

var type: Type
var card_id: String
var source_location_id: String
var target_location_id: String