extends Object

class_name GameLocation

var location_id: String
var cards_p1: Array[PlayedCard]
var cards_p2: Array[PlayedCard]
var total_power_p1: int
var total_power_p2: int

func _init(location_id: String):
	self.location_id = location_id
	self.cards_p1 = []
	self.cards_p2 = []
	self.total_power_p1 = 0
	self.total_power_p2 = 0
	
func copy() -> GameLocation:
	var result = GameLocation.new(location_id)
	
	result.cards_p1 = []
	for i in range(0, cards_p1.size()):
		result.cards_p1.append(cards_p1[i].copy())

	result.cards_p2 = []
	for i in range(0, cards_p2.size()):
		result.cards_p2.append(cards_p2[i].copy())

	result.total_power_p1 = total_power_p1
	result.total_power_p2 = total_power_p2
	return result
	
func get_data(db: DataBase) -> Location:
	return db.get_location(location_id)

func get_cards(player: int) -> Array[PlayedCard]:
	return cards_p1 if player == 1 else cards_p2
	
func get_total_power(player: int) -> int:
	return total_power_p1 if player == 1 else total_power_p2
