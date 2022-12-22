extends Control
const AREA_GAP = 33

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var OFFSET_PLAYER
var OFFSET_ENEMY

var location_id
var location_num
var location_name
var text

var power_up = 0
var power_down = 0
var drop_rect


func _ready():
	OFFSET_PLAYER = Vector2(46 + gui_state.CARD_WIDTH / 2, 1055 + gui_state.CARD_HEIGHT / 2)
	OFFSET_ENEMY = Vector2(46 + gui_state.CARD_WIDTH / 2, 35 + gui_state.CARD_HEIGHT / 2)
	drop_rect = Rect2($Player1/Frame.global_position, Vector2($Player1/Frame.size.x / 2, $Player1/Frame.size.y / 2))
	draw_rect(drop_rect, Color(1,0,0))
	
	
func init2(location_num, location_id, game_location):
	self.location_id = location_id
	self.location_num = location_num
	self.location_name = game_location.location_name
	self.text = game_location.text
	$Place/Image.texture = game_location.image
	
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	
	var mouse_inside = drop_rect.has_point(mouse_pos)
	if mouse_inside and gui_state.dragging_location != self:
		mouse_entered()
	elif not mouse_inside and gui_state.dragging_location == self:
		mouse_exited()
		

func redraw_location():	
	var x = OFFSET_PLAYER.x
	for card in gui_state.cards_location[location_num]:
		card.position.x = x
		card.position.y = OFFSET_PLAYER.y
		x += gui_state.CARD_WIDTH + AREA_GAP
		
	x = OFFSET_ENEMY.x
	for card in gui_state.cards_location_enemy[location_num]:
		card.position.x = x
		card.position.y = OFFSET_ENEMY.y
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


func mouse_entered():
	if gui_state.dragging:
		gui_state.dragging_location = self
		$Player1/Highlight.visible = true


func mouse_exited():
	$Player1/Highlight.visible = false
	gui_state.dragging_location = null
