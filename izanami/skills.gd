extends ItemList

var character_skills = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in character_skills:
		add_item(i.get('name'))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
