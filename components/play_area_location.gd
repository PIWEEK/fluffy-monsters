extends Control
const AREA_GAP = 33

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var location_num
var slug


func _ready():
	pass
	
func init(location_num, slug):
	self.location_num = location_num
	self.slug = slug
	$Image.texture = load("res://resources/images/locations/" + slug + ".png")
	

func _process(delta):
	pass

func _on_highlight_mouse_exited():
	$Highlight.visible = false
	gui_state.dragging_location = null
	
func _on_mouse_entered():
	if gui_state.dragging:
		gui_state.dragging_location = self
		$Highlight.visible = true

func redraw_location():
	var cards = ""
	for card in gui_state.cards_location[location_num]:
		cards += " " + card.slug
	print ("redrawing " + str(location_num) + " cards " + str(len(gui_state.cards_location[location_num])) + " " + cards)
	
	var x = 46
	for card in gui_state.cards_location[location_num]:
		card.position.x = x
		card.position.y = 35
		x += gui_state.CARD_WIDTH + AREA_GAP

func add_card(card):	
	gui_state.cards_location[location_num].append(card)
	add_child(card)
	redraw_location()
