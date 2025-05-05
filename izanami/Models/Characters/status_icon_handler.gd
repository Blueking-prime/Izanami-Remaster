class_name CharacterStatusIconHandler

extends Node

#@onready var get_parent().get_parent().status_icons: GridContainer = get_parent().get_parent().status_icons

@export var icon_scene: PackedScene

var status_icons: Dictionary = {}

func add_icon(status: Status):
	var icon: StatusEffectIcon = icon_scene.instantiate()

	icon.texture = status.icon
	icon.effect_name.text = status.desc
	icon.counter.text = str(status.duration - status.elapsed)

	status_icons.get_or_add(status, icon)
	get_parent().get_parent().status_icons.add_child(icon)

func tick_icon(status: Status):
	status_icons[status].counter.text = str(status.duration - status.elapsed)

func remove_icon(status: Status):
	if not status in status_icons: return

	var icon: StatusEffectIcon = status_icons[status]

	get_parent().get_parent().status_icons.remove_child(icon)
	status_icons.erase(status)
	icon.queue_free()


func clear_icons():
	for i in get_parent().get_parent().status_icons.get_children():
		get_parent().get_parent().status_icons.remove_child(i)
		i.queue_free()
