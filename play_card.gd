extends Node2D

@onready var gui_events = get_node("/root/GuiEvents")
var revealed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	reveal()

	
func reveal():
	$Front.visible = revealed
	$Back.visible = not revealed	


func _on_front_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			gui_events.emit_signal("start_drag_card", self)
			$Selected.visible = true
		elif event.button_index == 1 and !event.pressed:
			gui_events.emit_signal("stop_drag_card")
			$Selected.visible = false

