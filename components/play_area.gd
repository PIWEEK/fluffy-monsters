extends Node2D
var play_card_scene = preload("res://components/play_card.tscn")
var locations

var slugs = ["armed-monkey",
"astrounaut-mouse",
"baby-kaiju",
"chaos-hamster",
"cyber-deer",
"eye-cloud",
"fire-dragon",
"fire-tardigrade",
"genius-mouse",
"pirate-kraken",
"plant-dragon",
"raging-bigfoot"]

var slug_num = 0

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Location1.init (0, "tokyo")
	$Location2.init (1, "madrid")
	$Location3.init (2, "rio")
	
	
	
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
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
	var slug = slugs[slug_num]
	slug_num += 1
	card.init(slug, slug, 4, 5)
	$Hand.add_card(card)
	
func _on_stop_drag_card(card):	
	if gui_state.dragging_location != null:
		play_card(card, gui_state.dragging_location)

func play_card(card, location):	
	print ("add card to location " + str(location.location_num))
	$Hand.remove_card(card)
	location.add_card(card)
	card.draggable = false


