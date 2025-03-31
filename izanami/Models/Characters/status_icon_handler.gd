class_name CharacterStatusIconHandler

extends Node

#@onready var get_parent().get_parent().status_icons: GridContainer = get_parent().get_parent().status_icons

var status_icons: Dictionary = {}

func add_icon(status: Status):
	var icon: TextureRect = TextureRect.new()

	icon.texture = status.icon
	status_icons.get_or_add(status, icon)
	get_parent().get_parent().status_icons.add_child(icon)
	icon.add_to_group("status_icons")

func remove_icon(status: Status):
	if not status in status_icons: return

	var icon: TextureRect = status_icons[status]

	get_parent().get_parent().status_icons.remove_child(icon)
	status_icons.erase(status)
	icon.queue_free()


func clear_icons():
	for i in get_parent().get_parent().status_icons.get_children():
		get_parent().get_parent().status_icons.remove_child(i)
		i.queue_free()
