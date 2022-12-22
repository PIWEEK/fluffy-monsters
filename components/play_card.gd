extends Node2D

@onready var gui_events = get_node("/root/GuiEvents")
@onready var gui_state = get_node("/root/GuiState")

var revealed = true
var draggable = false
var slug: String = ""
var card_name: String = ""
var energy: int = 0
var power: int = 0

var card_image: Texture
var card_id
var belongs_to_player = false
var played_location = -1
var player = 0

var tween

func init(player: int, card_id, card: Card):	
	self.card_id = card_id
	self.player = player
	self.name = "%s-%s" % [player, card_id]
	print("HOLA", player, card_id)
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
	
func set_played_mode(is_played):
	if is_played:
		$Front/Frame.visible = false
		$Front/FrameSmall.visible = true
		$Front/Energy.visible = false
		$Front/Power.position.x = 255
		$Front/Power.position.y = 900
	else:
		$Front/Frame.visible = true
		$Front/FrameSmall.visible = false
		$Front/Energy.visible = true
		$Front/Power.position.x = 573
		$Front/Power.position.y = 807
	
func show_back():
	revealed = false
	scale.x = -0.2
	$Front/Power.visible = false
	$Back.visible = true
	
func reveal():
	var tween: Tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale:x", 0, 0.3)
	await tween.finished
	
	revealed = true
	$Front.visible = true
	$Back.visible = false
	$Front/Power.visible = true
	
	tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "scale:x", 0.2, 0.3)
	await tween.finished

func _on_front_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed and draggable:
			gui_state.dragging = true
			gui_state.dragging_card = self
			gui_events.emit_signal("start_drag_card", self)			
			$Front/FrameSelected.visible = true
		elif event.button_index == 1 and !event.pressed and draggable:
			gui_state.dragging = false
			gui_events.emit_signal("stop_drag_card", self)
			if draggable:
				position.y += 35
			$Front/FrameSelected.visible = false
			gui_state.dragging_card = null
		elif event.button_index == 2 and event.pressed:
			gui_events.emit_signal("show_zoom_card", self)



func _on_front_mouse_entered():
	if draggable and not gui_state.dragging:
		$Front/FrameSelected.visible = true
		gui_events.emit_signal("cursor_hover_card_start")
		position.y -= 35
	
func _on_front_mouse_exited():	
	if draggable and not gui_state.dragging:
		$Front/FrameSelected.visible = false
		gui_events.emit_signal("cursor_hover_card_end")
		position.y += 35

func set_power(value: int):
	$Front/Power/PowerLabel.text = str(value)
