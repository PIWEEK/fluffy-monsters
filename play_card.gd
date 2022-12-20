extends Node2D

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var revealed = true
var draggable = true

# Called when the node enters the scene tree for the first time.
func _ready():
	reveal()

	
func reveal():
	$Front.visible = revealed
	$Back.visible = not revealed	


func _on_front_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed and draggable:
			gui_state.dragging = true
			gui_state.dragging_card = self
			gui_events.emit_signal("start_drag_card", self)
			$Selected.visible = true
		elif event.button_index == 1 and !event.pressed and draggable:
			gui_state.dragging = false
			gui_events.emit_signal("stop_drag_card", self)
			$Selected.visible = false
			gui_state.dragging_card = null

