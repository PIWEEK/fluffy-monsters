extends Control

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var sound_on = preload("res://resources/images/ui/volume.png")
var sound_off = preload("res://resources/images/ui/mute.png")

var current_avatar
# Called when the node enters the scene tree for the first time.
func _ready():	
	$Bg/Control/LineEdit.text = gui_state.player_name
	current_avatar = get_node("Bg/Control/GridContainer//%s" % [gui_state.player_avatar])
	current_avatar.select(true)
	gui_events.connect("avatar_selected", _on_avatar_selected)
	if gui_state.sound_on:
		$Bg/Control/SoundButton.icon = sound_on
		$AudioStreamPlayer.play()
	else:
		$Bg/Control/SoundButton.icon = sound_off


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_avatar_selected(avatar):
	current_avatar.select(false)
	current_avatar = avatar
	current_avatar.select(true)
	

func _on_profile_button_pressed():
	gui_state.player_name = $Bg/Control/LineEdit.text
	gui_state.player_avatar = current_avatar.avatar_name
	gui_state.player_deck = current_avatar.deck_id
	save_profile()
	get_tree().change_scene_to_file("res://MainMenu.tscn")


func save_profile():
	var data_to_send = {"player_name": gui_state.player_name, \
						"player_avatar": gui_state.player_avatar, \
						"player_deck": gui_state.player_deck, \
						"sound_on": gui_state.sound_on}
	var json_string = JSON.stringify(data_to_send)
	var file = FileAccess.open("fluffy_profile.json", FileAccess.WRITE)
	file.store_string(json_string)
	


func _on_sound_button_pressed():
	gui_state.sound_on = not gui_state.sound_on
	if gui_state.sound_on:
		$Bg/Control/SoundButton.icon = sound_on
		$AudioStreamPlayer.play()
	else:
		$Bg/Control/SoundButton.icon = sound_off
		$AudioStreamPlayer.stop()
