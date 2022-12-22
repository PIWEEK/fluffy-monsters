extends Node

class_name LocationService

@onready var locations: Node = $"/root/DB/Locations"

func select_random_locations() -> Array[String]:
	var nodes = locations.get_children()
	var result: Array[String] = []
	
	for i in range(3):
		var idx = randi() % nodes.size()
		var loc_id: String = nodes[idx].name
		result.append(loc_id)
		nodes.remove_at(idx)
	return result

func get_location(state: GameState, location_id: String) -> GameLocation:
	if location_id == state.loc1.location_id: 
		return state.loc1
	elif location_id == state.loc2.location_id:
		return state.loc2
	else:
		return state.loc3
