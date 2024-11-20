extends ItemList


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var run = add_item('Run')
	var attack = add_item('Attack')

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
