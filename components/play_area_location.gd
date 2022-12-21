extends Control
const AREA_GAP = 33

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var location_id
var location_num
var location_name
var text

var power_up = 0
var power_down = 0


func _ready():
	pass
	
func init2(location_num, location_id, game_location):
	self.location_id = location_id
	self.location_num = location_num
	self.location_name = game_location.location_name
	self.text = game_location.text
	$Place/Image.texture = game_location.image
	

func _process(delta):
	pass

func redraw_location():	
	var x = 46
	for card in gui_state.cards_location[location_num]:
		card.position.x = x
		card.position.y = 1055
		x += gui_state.CARD_WIDTH + AREA_GAP
		
	x = 46
	for card in gui_state.cards_location_enemy[location_num]:
		card.position.x = x
		card.position.y = 35
		x += gui_state.CARD_WIDTH + AREA_GAP
		
	$Place/PowerUp.text = str(power_up)
	$Place/PowerDown.text = str(power_down)
		
	$Place/RibonWinDown.visible = false
	$Place/RibonWinUp.visible = false
	
	if power_up > power_down:
		$Place/RibonWinUp.visible = true
	if power_up < power_down:
		$Place/RibonWinDown.visible = true

func add_card(card):	
	gui_state.cards_location[location_num].append(card)
	add_child(card)
	redraw_location()

func add_enemy_card(card):	
	gui_state.cards_location_enemy[location_num].append(card)	
	add_child(card)
	redraw_location()


func _on_player_1_mouse_entered():
	if gui_state.dragging:
		gui_state.dragging_location = self
		$Player1/Highlight.visible = true


func _on_player_1_highlight_mouse_exited():
	$Player1/Highlight.visible = false
	gui_state.dragging_location = null
