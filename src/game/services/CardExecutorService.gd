extends Node

class_name CardExecutorService

@onready var db: DataBase = $"/root/DB"

func play_card(state: GameState, played_card: PlayedCard, player: int, location: GameLocation):
	var card = db.get_card(played_card.card_id)
	var script = card.get_node("on-self-reveal")
	if script:
		script.execute(state, played_card, player, location)

