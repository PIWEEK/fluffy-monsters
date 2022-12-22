extends Node

class_name CardExecutorService

@onready var db: DataBase = $"/root/DB"

func before_reveal(state: GameState, played_card: PlayedCard, player: int, location: GameLocation):
	var card = db.get_card(played_card.card_id)
	var script: OnSelfReveal = card.on_self_reveal
	if script:
		script.execute(state, played_card, player, location)

func after_reveal(state: GameState, played_card: PlayedCard, player: int, location: GameLocation):
	for other_location in state.get_locations():
		for other_card in other_location.cards_p1:
			var card = db.get_card(other_card.card_id)
			var script: OnCardPlay = card.on_card_play
			if script:
				script.execute(state, other_card, other_location, 1, played_card, player, location)
		for other_card in other_location.cards_p2:
			var card = db.get_card(other_card.card_id)
			var script: OnCardPlay = card.on_card_play
			if script:
				script.execute(state, other_card, other_location, 2, played_card, player, location)

func begin_turn(state: GameState):
	for other_location in state.get_locations():
		for other_card in other_location.cards_p1:
			var card = db.get_card(other_card.card_id)
			var script: OnBeginTurn = card.on_begin_turn
			if script:
				script.execute(state, other_card, other_location, 1)
		for other_card in other_location.cards_p2:
			var card = db.get_card(other_card.card_id)
			var script: OnBeginTurn = card.on_begin_turn
			if script:
				script.execute(state, other_card, other_location, 2)

func end_turn(state: GameState):
	for other_location in state.get_locations():
		for other_card in other_location.cards_p1:
			var card = db.get_card(other_card.card_id)
			var script: OnEndTurn = card.on_begin_turn
			if script:
				script.execute(state, other_card, other_location, 1)
		for other_card in other_location.cards_p2:
			var card = db.get_card(other_card.card_id)
			var script: OnEndTurn = card.on_begin_turn
			if script:
				script.execute(state, other_card, other_location, 2)

func after_discard(state: GameState, hand_card: HandCard, player):
	for other_location in state.get_locations():
		for other_card in other_location.cards_p1:
			var card = db.get_card(other_card.card_id)
			var script: OnDiscard = card.on_discard
			if script:
				script.execute(state, other_card, other_location, hand_card, player)
		for other_card in other_location.cards_p2:
			var card = db.get_card(other_card.card_id)
			var script: OnDiscard = card.on_discard
			if script:
				script.execute(state, other_card, other_location, hand_card, player)

func after_destroy(state: GameState, played_card: PlayedCard, player: int, location: GameLocation):
	for other_location in state.get_locations():
		for other_card in other_location.cards_p1:
			var card = db.get_card(other_card.card_id)
			var script: OnDestroy = card.on_destroy
			if script:
				script.execute(state, other_card, other_location, 1, played_card, player, location)
		for other_card in other_location.cards_p2:
			var card = db.get_card(other_card.card_id)
			var script: OnDestroy = card.on_destroy
			if script:
				script.execute(state, other_card, other_location, 2, played_card, player, location)
