extends TextureRect
var revealed = true

# Called when the node enters the scene tree for the first time.
func _ready():
	reveal()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_revealed(revealed):
	self.revealed = revealed
	reveal()
	
func reveal():
	if revealed:
		$"../Front".visible = true
		$Back.visible = false
	else:
		$Front.visible = false
		$Back.visible = true
