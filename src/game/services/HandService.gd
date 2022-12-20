extends Node

class_name HandService

func draw(deck: Array[Card], hand: Array[HandCard], num_cards: int = 1):
	for i in num_cards:
		var card = deck.pop_front()
		hand.push_back(HandCard.new(card))

func find_card_idx(hand: Array[HandCard], card_id: String) -> int:
	var cur = 0
	while cur < hand.size() and hand[cur].card_id != card_id:
		cur += 1
	return cur if cur < hand.size() else -1

func remove_card(hand: Array[HandCard], card_id: String) -> HandCard:
	var idx = find_card_idx(hand, card_id)
	if idx >= 0:
		var result = hand[idx]
		hand.remove_at(idx)
		return result
	return null
