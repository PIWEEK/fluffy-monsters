extends Control

@onready var db: DataBase = $"/root/DB"

var card

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		queue_free()

func init(card):
	self.card = card

func _ready():
	$Label.text = db.get_card(card.card_id).card_name
	$DetailedCard.copy(card)
