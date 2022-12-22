extends Control

@onready var db: DataBase = $"/root/DB"

var card

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		queue_free()

func init(card):
	self.card = card

func _ready():
	var card_data: Card = db.get_card(card.card_id)
	$Label.text = card_data.card_name
	$Description.text = "[center]%s[/center]" % [card_data.text]
	$DetailedCard.copy(card)
