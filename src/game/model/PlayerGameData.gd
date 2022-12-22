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
	
func copy() -> PlayerGameData:
	var result = PlayerGameData.new(0, [])
	result.player_number = player_number
	result.energy = energy
	result.hand = []
	for i in range(0, len(hand)):
		result.hand.append(hand[i].copy())
	result.deck = []
	for i in range(0, len(deck)):
		result.deck.append(deck[i])
	result.discards = []
	for i in range(0, len(discards)):
		result.discards.append(discards[i])
	return result
