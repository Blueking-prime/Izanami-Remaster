extends Node

class_name MenuSwitcher

@export var menu_container: Control

@export var indicator_left: Control
@export var indicator_right: Control

var menus: Array

func get_current_menu() -> int:
	menus = menu_container.get_children()

	for i in len(menus):
		if menus[i].visible:
			return i

	return 0

func move_left():
	var index: int = get_current_menu()

	menus[index - 1].show()
	#menus[index].hide()

func move_right():
	var index: int = get_current_menu()

	if index + 1 >= len(menus):
		index = -1

	menus[index + 1].show()
	#menus[index].hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed('menu_left'):
		move_left()
	if event.is_action_pressed('menu_right'):
		move_right()
