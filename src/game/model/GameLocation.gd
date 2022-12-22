extends Object

class_name GameLocation

var location_id: String
var cards_p1: Array[PlayedCard]
var cards_p2: Array[PlayedCard]

func _init(location_id: String):
	self.location_id = location_id
	self.cards_p1 = []
	self.cards_p2 = []
	
func copy() -> GameLocation:
	var result = GameLocation.new(location_id)
	
	result.cards_p1 = []
	for i in range(0, cards_p1.size()):
		result.cards_p1.append(cards_p1[i].copy())

	result.cards_p2 = []
	for i in range(0, cards_p2.size()):
		result.cards_p2.append(cards_p2[i].copy())

	return result
	
func get_data(db: DataBase) -> Location:
	return db.get_location(location_id)

func get_cards(player: int) -> Array[PlayedCard]:
	return cards_p1 if player == 1 else cards_p2
	
func get_opponent_cards(player:int) -> Array[PlayedCard]:
	return cards_p2 if player == 1 else cards_p1

func get_total_power(player: int) -> int:
	var cards = get_cards(player)
	var result = 0
	for c in cards:
		if not c.flags.has("destroy"):
			result += c.current_power
	return result
