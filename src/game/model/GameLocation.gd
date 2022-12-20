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

