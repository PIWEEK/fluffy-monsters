extends Control

@onready var db: DataBase = $"/root/DB"

var card

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		queue_free()

func init(location):
	$Image.texture = location.texture
	$Label.text = location.location_name
