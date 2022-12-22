extends Object

class_name PlayedCard

var card_id: String
var modifiers: Array[Modifier]
var current_power: int
var current_cost: int

func _init(card = null):
	if card is HandCard:
		self.card_id = card.card_id
		self.modifiers = card.modifiers
		self.current_power = card.current_power
		self.current_cost = card.current_cost
	elif card:
		self.card_id = card.name
		self.modifiers = []
		self.current_power = card.power
		self.current_cost = card.cost

func copy() -> PlayedCard:
	var result = PlayedCard.new()
	result.card_id = card_id
	result.modifiers = []
	for i in range(0, modifiers.size()):
		result.modifiers.append(modifiers[i].duplicate())
	result.current_power = current_power
	result.current_cost = current_power
	return result

func get_data(db: DataBase) -> Card:
	return db.get_card(card_id)
