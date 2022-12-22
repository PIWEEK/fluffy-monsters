extends Control

func _ready():
	# seed(0)
	randomize()

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
func _on_profile_button_pressed():
	get_tree().change_scene_to_file("res://profile.tscn")
