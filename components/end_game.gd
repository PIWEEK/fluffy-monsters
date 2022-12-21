extends Control

@onready var events = $"/root/Events"

var current_player
func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		events.emit_signal("finish_game_end", current_player)
		get_tree().change_scene_to_file("res://MainMenu.tscn")
		queue_free()

func init(is_victory, current_player):
	self.current_player = current_player
	$Victory.visible = is_victory
	$Defeat.visible = not is_victory

func _ready():
	pass
