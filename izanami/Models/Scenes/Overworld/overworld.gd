extends Node

class_name Overworld

@export var map: TextureRect
@export var player_marker: Sprite2D
@export_range(0, 1, 0.01) var encounter_chance: float
@export var encounter_flags: Dictionary[StringName, bool]
@export var encounter_enemies: Array[PackedScene]

var visible_pins: Array[LocationPin]:
	set(arg):
		visible_pins = arg
		visible_pins.sort_custom(func(a, b): return a.global_position < b.global_position)
var current_pin_index: int:
	set(value): current_pin_index = maxi(value, 0)
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

func navigate_to_pins(pin: Sprite2D):
	player_marker.global_position = pin.global_position

func get_current_node():
	current_pin_index = visible_pins.find_custom(func (x): return x.destination == source_location.name)
	navigate_to_pins(visible_pins[current_pin_index])

func select_destination():
	if Global.rand_chance(encounter_chance) and not Checks.check_flags(encounter_flags.keys()):
		start_battle()
	else:
		Global.warp(source_location, Global.town_scenes[visible_pins[current_pin_index].destination])
	queue_free()

func start_battle():
	LoadingScreen.show()
	var battle: Battle = Global.battle_scene.instantiate()
	battle.rand_spawn = false

	battle.town = source_location

	battle.flags = encounter_flags
	battle.enemy_set = encounter_enemies

	source_location.hide()
	source_location.overlay.disable()
	source_location.call_deferred("add_sibling", battle)

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
		select_destination()
