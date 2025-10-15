extends Node

class_name Overworld

@export var map: TextureRect
@export var player_marker: Sprite2D
var visible_pins: Array[LocationPin]:
	set(arg):
		visible_pins = arg
		visible_pins.sort_custom(func(a, b): return a.global_position < b.global_position)
var current_pin_index: int
var source_location: Location

func _ready() -> void:
	show_pins()

func show_pins():
	visible_pins = []
	for i in map.get_children():
		if i is LocationPin and Checks.check_flags(i.flags):
			visible_pins.append(i)
			i.show()
		else :
			i.hide()
	get_current_node()
	print(visible_pins)

func navigate_to_pins(pin: Sprite2D):
	player_marker.global_position = pin.global_position
	print(pin, ' ', current_pin_index)

func get_current_node():
	current_pin_index = 0

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left") or event.is_action_pressed("ui_down"):
		if current_pin_index + 1 < visible_pins.size():
			current_pin_index += 1
		else :
			current_pin_index = 0
		navigate_to_pins(visible_pins[current_pin_index])
	if event.is_action_pressed("ui_right") or event.is_action_pressed("ui_up"):
		if current_pin_index - 1 >= 0:
			current_pin_index -= 1
		else :
			current_pin_index = visible_pins.size() - 1
		navigate_to_pins(visible_pins[current_pin_index])
	if event.is_action_pressed("ui_accept"):
		#Global.warp(source_location, visible_pins[current_pin_index].destination)
		Global.warp(source_location, Global.town_scene)
		#await get_tree().create_timer(3).timeout
		queue_free()
