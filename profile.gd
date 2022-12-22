extends Control

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var current_avatar
# Called when the node enters the scene tree for the first time.
func _ready():
	current_avatar = $Bg/Control/GridContainer/Avatar1
	current_avatar.select(true)
	gui_events.connect("avatar_selected", _on_avatar_selected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_avatar_selected(avatar):
	current_avatar.select(false)
	current_avatar = avatar
	current_avatar.select(true)
	

func _on_profile_button_pressed():
	gui_state.player_name = $Bg/Control/LineEdit.text
	gui_state.player_avatar = current_avatar.avatar_texture
	get_tree().change_scene_to_file("res://MainMenu.tscn")
