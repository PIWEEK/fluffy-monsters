extends Object

class_name PlayerAction

enum Type {
	PLAY_CARD,
	MOVE_CARD
}

var type: Type
var card_id: String
var target_location_id: String

func _init(card_id: String, target_location_id: String):
	self.type = Type.PLAY_CARD
	self.card_id = card_id
	self.target_location_id = target_location_id
