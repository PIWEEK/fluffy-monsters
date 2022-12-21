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

var tween

func init(card_id, card: Card):	
	self.card_id = card_id
	self.name = card.card_name
	self.slug = card.name
	self.energy = card.cost
	self.power = card.power
	self.card_image = card.image
	redraw()

func copy(card):
	self.card_id = card.card_id
	self.name = card.name
	self.slug = card.slug
	self.energy = card.energy
	self.power = card.power
	self.card_image = card.card_image
	redraw()

func redraw():
	$Front/Energy/EnergyLabel.text = str(energy)
	$Front/Power/PowerLabel.text = str(power)
	# $Front/Hole/Image.texture = load("res://resources/images/monsters/" + slug + ".png")
	$Front/Hole/Image.texture = card_image

func _ready():
	pass
	
func show_back():
	revealed = false
	$Front.visible = false
	$Back.visible = true
	
func reveal():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 0, 1)
	tween.tween_callback(end_reveal)

func end_reveal():
	revealed = true
	$Front.visible = true
	$Back.visible = false
	var tween = get_tree().create_tween()
	tween.tween_property(self, "modulate:a", 1, 1)
	tween.tween_callback(end_reveal)


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
		elif event.button_index == 2 and event.pressed:
			gui_events.emit_signal("show_zoom_card", self)

