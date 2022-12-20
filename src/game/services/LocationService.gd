extends Node

class_name LocationService

@onready var locations: Node = $"/root/DB/Locations"

func _ready():
	randomize()

func select_random_locations() -> Array[String]:
	var nodes = locations.get_children()
	var result: Array[String] = []
	
	for i in range(3):
		var idx = randi() % nodes.size()
		var loc_id: String = nodes[idx].name
		result.append(loc_id)
		nodes.remove_at(idx)
	return result
