extends TextureRect

@onready var gui_events = get_node("/root/GuiEvents")

@export var avatar_name : String = ""
@export var deck_id : String = ""
@export var avatar_texture : Texture = null

# Called when the node enters the scene tree for the first time.
func _ready():
	$Hole/Image.texture = avatar_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func select(selected):
	$FrameSelected.visible = selected


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			gui_events.emit_signal("avatar_selected", self)

