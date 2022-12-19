extends Node2D

var game_size

func _ready():
	game_size = Vector2(ProjectSettings.get_setting("display/window/size/viewport_width"), ProjectSettings.get_setting("display/window/size/viewport_height"))
	#viewport.connect("size_changed", self, "resize_viewport")
	#DisplayServer.window_set_rect_changed_callback(Callable(self, "resize_viewport"))
	resize_viewport()
	get_tree().root.connect("size_changed", Callable(self, "resize_viewport"))

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
	print ("resizing..." + str(new_size) + " " + str(game_size)+ " " + str(scale_factor))
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

