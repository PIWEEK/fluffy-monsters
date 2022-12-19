extends Node2D
const CARD_WIDTH = 200
const HAND_GAP = 50
const AREA_GAP = 10
var play_card_scene = preload("res://play_card.tscn")
var hand_cards = []
var area1_cards = []
var area2_cards = []
var area3_cards = []
var area_cards = [area1_cards, area2_cards, area3_cards]
var dragging = false
var current_mouse_area = null
var current_card = null
var areas

@onready var gui_events = get_node("/root/GuiEvents")

# Called when the node enters the scene tree for the first time.
func _ready():
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	gui_events.connect("stop_drag_card", _on_stop_drag_card)
	gui_events.connect("start_drag_card", _on_start_drag_card)
	areas = [$Area1, $Area2, $Area3]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func draw_card():
	var card = play_card_scene.instantiate()
	hand_cards.append(card)
	$Hand.add_child(card)
	redraw_hand()
	
func redraw_hand():
	var x = ($Background.size.x / 2 - CARD_WIDTH / 2) - ((len(hand_cards) - 1) / 2) * (CARD_WIDTH + HAND_GAP)
	
	for card in hand_cards:
		card.position.x = x
		x += (CARD_WIDTH + HAND_GAP)
	

func _on_area_1_mouse_entered():
	if dragging:
		current_mouse_area = 0
		$Area1/Highlight.visible = true

func _on_area_2_mouse_entered():
	if dragging:
		current_mouse_area = 1
		$Area2/Highlight.visible = true

func _on_area_3_mouse_entered():
	if dragging:
		current_mouse_area = 2
		$Area3/Highlight.visible = true

func _on_highlight_mouse_exited():
	current_mouse_area = null
	$Area1/Highlight.visible = false
	$Area2/Highlight.visible = false
	$Area3/Highlight.visible = false
	
func _on_start_drag_card(card):
	dragging = true
	current_card = card
	
func _on_stop_drag_card():
	dragging = false
	if current_mouse_area != null and current_card != null:
		play_card(current_card, current_mouse_area)
		current_card = null
		
		
func play_card(card, area):
	remove_card_from_hand(card)	
	add_card_to_area(card, area)
	
func remove_card_from_hand(card):
	$Hand.remove_child(card)
	hand_cards.erase(card)
	redraw_hand()	
		
func add_card_to_area(card, area):	
	area_cards[area].append(card)
	areas[area].add_child(card)
	redraw_area(area)
	
func redraw_area(area):
	var x = 5
	
	for card in area_cards[area]:
		card.position.x = x
		card.position.y = 0
		x += CARD_WIDTH + AREA_GAP
		
