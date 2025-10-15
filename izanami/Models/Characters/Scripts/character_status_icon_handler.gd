class_name CharacterStatusIconHandler

extends Node

#@onready var status_icon_container: GridContainer = status_icon_container

@export var icon_scene: PackedScene

var status_icon_container: GridContainer:
	get():
		return get_parent().get_parent().status_icon_container

var status_icon_dict: Dictionary = {}

func add_icon(status: Status):
	var icon: StatusEffectIcon = icon_scene.instantiate()

	icon.texture = status.icon
	icon.effect_name.text = status.desc
	icon.counter.text = str(status.duration - status.elapsed)

	status_icon_dict.get_or_add(status, icon)
	status_icon_container.add_child(icon)

func tick_icon(status: Status):
	if is_instance_valid(status_icon_dict[status]):	status_icon_dict[status].counter.text = str(status.duration - status.elapsed)

func remove_icon(status: Status):
	if status not in status_icon_dict: return

	if status_icon_dict[status].get_parent() == status_icon_container:
		status_icon_container.remove_child(status_icon_dict[status])

	status_icon_dict.erase(status)

func clear_icons():
	for i in status_icon_container.get_children():
		status_icon_container.remove_child(i)
