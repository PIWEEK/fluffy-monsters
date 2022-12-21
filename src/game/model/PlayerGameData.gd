extends Object

class_name PlayerGameData

var player_number: int
var energy: int
var hand: Array[HandCard]
var deck: Array[Card]
var discards: Array[Card]

func _init(player_number: int, deck: Array[Card]):
	self.player_number = player_number
	self.energy = 0
	self.hand = []
	self.deck = deck
	self.discards = []
