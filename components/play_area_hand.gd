extends Control

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

const HAND_GAP = 50

func redraw():
	var x = (size.x / 2 - gui_state.CARD_WIDTH / 2) - ((len(gui_state.cards_hand) - 1) / 2) * (gui_state.CARD_WIDTH + HAND_GAP)
	
	for card in gui_state.cards_hand:
		card.position.x = x
		x += (gui_state.CARD_WIDTH + HAND_GAP)
		
func add_card(card):
	gui_state.cards_hand.append(card)
	add_child(card)
	redraw()
	
func remove_card(card):
	gui_state.cards_hand.erase(card)
	remove_child(card)
	redraw()
	
func remove_all_cards():
	for card in get_children():
		gui_state.cards_hand.erase(card)
		remove_child(card)
