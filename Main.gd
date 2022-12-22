extends Node2D

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var game_size
var cursor_card = null
var cursor_card_pos
var cursor_normal = load("res://resources/images/ui/cursor-normal.png")
var cursor_drag = load("res://resources/images/ui/cursor-drag.png")
var cursor_pointer = load("res://resources/images/ui/cursor-pointer.png")
var arrow = load("res://arrow.png")

func _ready():
	cursor_card_pos = Vector2(gui_state.CARD_WIDTH/2, gui_state.CARD_HEIGHT/2)
	game_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), 
						ProjectSettings.get_setting("display/window/size/viewport_height"))
	#viewport.connect("size_changed", self, "resize_viewport")
	#DisplayServer.window_set_rect_changed_callback(Callable(self, "resize_viewport"))
	resize_viewport()
	get_tree().root.connect("size_changed", Callable(self, "resize_viewport"))
	gui_events.connect("start_drag_card", _on_start_drag_card)
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	gui_events.connect("cursor_hover_card_start", _on_cursor_hover_card_start)
	gui_events.connect("cursor_hover_card_end", _on_cursor_hover_card_end)


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
	Input.set_custom_mouse_cursor(cursor_drag)
	
func _on_stop_drag_card(card):
	if cursor_card != null:
		remove_child(cursor_card)
	Input.set_custom_mouse_cursor(cursor_normal)
	
func _process(delta):	
	if cursor_card != null:
		var mousepos = get_global_mouse_position()
		cursor_card.position = Vector2(mousepos.x, mousepos.y)
		
func _on_cursor_hover_card_start():
	Input.set_custom_mouse_cursor(cursor_pointer)
	
func _on_cursor_hover_card_end():
	Input.set_custom_mouse_cursor(cursor_normal)
		

