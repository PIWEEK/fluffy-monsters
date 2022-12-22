extends Node

class_name DataBase

func get_card(id: String) -> Card:
	return get_node("Cards/%s" % [id])
	
func get_location(id: String) -> Location:
	return get_node("Locations/%s" % [id])
	
func get_deck(id: String) -> CustomDeck:
	return get_node("Decks/%s" % [id])
	
func get_avatar(id: String) -> Avatar:
	return get_node("Avatars/%s" % [id])
