extends Control
const AREA_GAP = 10

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var location_num


func _ready():
	pass

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
	var x = 5	
	for card in gui_state.cards_location[location_num]:
		card.position.x = x
		card.position.y = 0
		x += gui_state.CARD_WIDTH + AREA_GAP

func add_card(card):	
	gui_state.cards_location[location_num].append(card)
	add_child(card)
	redraw_location()
