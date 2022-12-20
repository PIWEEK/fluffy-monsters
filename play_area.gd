extends Node2D
var play_card_scene = preload("res://play_card.tscn")
var locations

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Location1.location_num = 0
	$Location2.location_num = 1
	$Location3.location_num = 2
	
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	locations = [$Location1, $Location2, $Location3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_card():
	var card = play_card_scene.instantiate()
	gui_state.cards_hand.append(card)
	$Hand.add_card(card)
	
func _on_stop_drag_card(card):	
	if gui_state.dragging_location != null:
		play_card(card, gui_state.dragging_location)
		
		
func play_card(card, location):	
	$Hand.remove_card(card)
	location.add_card(card)
	card.draggable = false
	

