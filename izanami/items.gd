extends ItemList

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for x in get_parent().inventory_data:
		if x['type'] == 'item':
			add_item(x['name'])


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
