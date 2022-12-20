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

@onready var events = $"/root/Events"
@onready var db: DataBase = $"/root/DB"
@onready var next_turn_button = $NextTurnButton

# Called when the node enters the scene tree for the first time.
func _ready():
	$Location1.init (0, "city-ny")
	$Location2.init (1, "city-paris")
	$Location3.init (2, "city-rome")
	
	#draw_card()
	#draw_card()
	#draw_card()
	#draw_card()
	##draw_card()
	#draw_card()
	#draw_card()
	#draw_card()
	#draw_card()
	##draw_card()
	#draw_card()
	#draw_card()
	
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	locations = [$Location1, $Location2, $Location3]
	
	events.connect("play_start", _on_play_start)
	events.connect("draw_start", _on_draw_start)
	events.connect("finish_turn_start", _on_finish_turn_start)

func _on_play_start():
	# Allow the user to move cards
	next_turn_button.disabled = false
	pass
	
func _on_finish_turn_start():
	# Disallow the user to move cards
	next_turn_button.disabled = true
	pass
	
func _on_draw_start():
	# Now it's deleting the whole hand and redrawing
	var children = $Hand.get_children()
	for node in children:
		$Hand.remove_child(node)
	
	var cards: Array[HandCard] = $PlayerController.get_hand_cards()
	
	for card in cards:
		var card_scene = play_card_scene.instantiate()
		card_scene.init2(db.get_card(card.card_id))
		card_scene.energy = card.current_cost
		card_scene.power = card.current_power
		$Hand.add_card(card_scene)
	$Hand.redraw()
	$PlayerController.draw_finished()

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


