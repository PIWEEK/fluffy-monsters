extends Node2D

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var revealed = true
var draggable = true
var slug: String = ""
var card_name: String = ""
var energy: int = 0
var power: int = 0

var card_image: Texture
var card_id

func init(card_id, card: Card):
	self.card_id = card_id
	self.name = card.card_name
	self.slug = card.name
	self.energy = card.cost
	self.power = card.power
	self.card_image = card.image
	redraw()
	
func redraw():
	$Front/Energy/EnergyLabel.text = str(energy)
	$Front/Power/PowerLabel.text = str(power)
	# $Front/Hole/Image.texture = load("res://resources/images/monsters/" + slug + ".png")
	$Front/Hole/Image.texture = card_image

func _ready():
	reveal()

	
func reveal():
	$Front.visible = revealed
	$Back.visible = not revealed	


func _on_front_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed and draggable:
			gui_state.dragging = true
			gui_state.dragging_card = self
			gui_events.emit_signal("start_drag_card", self)
			$Selected.visible = true
		elif event.button_index == 1 and !event.pressed and draggable:
			gui_state.dragging = false
			gui_events.emit_signal("stop_drag_card", self)
			$Selected.visible = false
			gui_state.dragging_card = null

