extends PanelContainer

class_name DungeonEnemyDisplay

@export var container: VBoxContainer

func update_display():
	_clear_container()
	for i in get_parent().get_parent().tilemap.enemy_nodes:
		if not is_instance_valid(i): continue

		var entry: Label = Label.new()
		entry.text = i.character_name

		container.add_child(entry)

	show()
	if not container.get_children(): hide()

func _clear_container():
	for i in container.get_children():
		if is_instance_valid(i):
			container.remove_child(i)
			i.queue_free()
