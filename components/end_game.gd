extends Control


func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		queue_free()

func set_player_victory(is_victory):
	$Victory.visible = is_victory
	$Defeat.visible = not is_victory

func _ready():
	pass
