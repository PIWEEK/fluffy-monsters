extends Object

class_name PlayerAction

enum Type {
	PLAY_CARD,
	MOVE_CARD
}

var type: Type
var card_id: String
var target_location_id: String

func _init(cid: String, locid: String):
	self.type = Type.PLAY_CARD
	self.card_id = cid
	self.target_location_id = locid

func get_card(db: DataBase) -> Card:
	return db.get_card(card_id)

func get_target_location(db: DataBase) -> Location:
	return db.get_location(target_location_id)
