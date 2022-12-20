extends Node

class_name HandService

func draw(deck: Array[Card], hand: Array[HandCard], num_cards: int = 1) -> Array[HandCard]:
	for i in num_cards:
		var card = deck.pop_front()
		hand.push_back(HandCard.new(card))
	return hand
