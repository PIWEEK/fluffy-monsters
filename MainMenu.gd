extends Control

@onready var gui_state = get_node("/root/GuiState")

func _ready():
	seed(0)
	#randomize()
	load_profile()
	if gui_state.sound_on:
		$AudioStreamPlayer.play()

func _on_start_game_button_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
func _on_profile_button_pressed():
	get_tree().change_scene_to_file("res://profile.tscn")
	
func load_profile():
	if FileAccess.file_exists("fluffy_profile.json"):
		var file = FileAccess.open("fluffy_profile.json", FileAccess.READ)
		var content = file.get_as_text()
		var data = JSON.parse_string(content)
		gui_state.player_name = data.player_name
		gui_state.player_avatar = data.player_avatar
		gui_state.player_deck = data.player_deck
		if data.has('sound_on'):
			gui_state.sound_on = data.sound_on
