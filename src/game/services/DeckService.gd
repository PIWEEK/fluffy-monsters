extends Node

class_name DeckService

@onready var db: DataBase = $"/root/DB"

func retrieve_deck(id: String) -> Array[Card]:
	var deck = db.get_deck(id)
	return [
		deck.card1,
		deck.card2,
		deck.card3,
		deck.card4,
		deck.card5,
		deck.card6,
		deck.card7,
		deck.card8,
		deck.card9,
		deck.card10,
		deck.card11,
		deck.card12
	]

func shuffle(deck: Array[Card]):
	deck.shuffle()
