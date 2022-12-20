extends Node2D

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var game_size
var cursor_card = null

func _ready():
	game_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	#viewport.connect("size_changed", self, "resize_viewport")
	#DisplayServer.window_set_rect_changed_callback(Callable(self, "resize_viewport"))
	resize_viewport()
	get_tree().root.connect("size_changed", Callable(self, "resize_viewport"))
	gui_events.connect("start_drag_card", _on_start_drag_card)
	gui_events.connect("stop_drag_card", _on_stop_drag_card)

func resize_viewport():
	var new_size = DisplayServer.window_get_size()
	var scale_factor_x = 1	
	var scale_factor_y = 1
	
	if new_size.x != game_size.x:
		scale_factor_x = new_size.x / game_size.x
		
	if new_size.y != game_size.y:
		scale_factor_y = new_size.y / game_size.y
		
	var scale_factor = min(scale_factor_x, scale_factor_y)
			
	$Camera2D.zoom.x = scale_factor
	$Camera2D.zoom.y = scale_factor
	
	
func _on_start_drag_card(card):
	if cursor_card != null:
		remove_child(cursor_card)
		
	cursor_card = card.duplicate()
	add_child(cursor_card)
	
func _on_stop_drag_card(card):
	if cursor_card != null:
		remove_child(cursor_card)
	
func _process(delta):	
	if cursor_card != null:
		var mousepos = get_global_mouse_position()
		cursor_card.position = Vector2(mousepos.x + 15, mousepos.y + 15)

