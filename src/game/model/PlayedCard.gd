extends Object

class_name PlayedCard

var card_id: String
var modifiers: Array[Modifier]
var current_power: int
var current_cost: int

func _init(card):
	if card is HandCard:
		self.card_id = card.card_id
		self.modifiers = card.modifiers
		self.current_power = card.current_power
		self.current_cost = card.current_cost
	else:
		self.card_id = card.name
		self.modifiers = []
		self.current_power = card.power
		self.current_cost = card.cost

func get_data(db: DataBase) -> Card:
	return db.get_card(card_id)
