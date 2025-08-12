extends Node

@export_category("Sub Nodes")
@export var TEXT: GlobalTextProcessing
@export var UI: GlobalUIElements
@export var ALGORITHMS: GlobalAlgorithms
@export var SCENE_LOADER: GlobalSceneLoader
@export var QUESTS: GlobalQuests

@export_category("UI Asset Scenes")
@export var text_box_scene: PackedScene
@export var confirmation_box_scene: PackedScene
@export var description_box_scene: PackedScene
@export var shop_menu_scene: PackedScene
@export var text_log_scene: PackedScene
@export var loading_screen: AnimatedTexture

@export_category("Game Scenes")
@export var town_scene: PackedScene
@export var dungeon_scene: PackedScene
@export var demonitarium_scene: PackedScene
@export var battle_scene: PackedScene
@export var main_menu_scene: PackedScene


var players: Party


# WORKING OBJECTS
var description_box_parent: Node
var description_box: DescriptionBox
var root_canvas_layer: CanvasLayer
var background_texture: TextureRect
var shop_menu: Control
var text_box: TextBox
var action_log: Label
var confirmation_box: ConfirmationDialog
var text_log: TextLog
var exit_button: Button

var path_checker: Callable

# RESPONSES
var textbox_response: int
var confrimation_response: bool

# TEXTBOX FLAGS
var textbox_skip_flag: bool
var textbox_auto_flag: bool
var textbox_ffwd_flag: bool

var scroll_state: bool

var active_quest_list: Array[GlobalQuests.Quest]

#region REGEX EXplanation
#\{(\w+)\:?(\w*)\} should catch all tags in the format {x}, {x:y} where x and y are any arbitrary strings
	#\{ matches the character { with index 12310 (7B16 or 1738) literally (case sensitive)
	#1st Capturing Group (\w*)
	#\w matches any word character (equivalent to [a-zA-Z0-9_])
	#+ matches the previous token between one and unlimited times, as many times as possible, giving back as needed (greedy)
	#\: matches the character : with index 5810 (3A16 or 728) literally (case sensitive)
	#? matches the previous token between zero and one times, as many times as possible, giving back as needed (greedy)
	#2nd Capturing Group (\w*)
	#\w matches any word character (equivalent to [a-zA-Z0-9_])
	#* matches the previous token between zero and unlimited times, as many times as possible, giving back as needed (greedy)
	#\} matches the character } with index 12510 (7D16 or 1758) literally (case sensitive)
#endregion
var custom_tags_filter: RegEx = RegEx.create_from_string(r'\{(\w+)\:?(\w*)\}')

# SIGNALS
signal next
signal pause_timer
signal confirmation_box_triggered
signal sell(condition)
signal exit_signal


#region Text Processing
func add_to_text_log(dialogue: Array):
	return TEXT.add_to_text_log(dialogue)

func clear_custom_tags(_text: String) -> String:
	return TEXT.clear_custom_tags(_text)

func print_to_log(text: Variant):
	return TEXT.print_to_log(text)
#endregion

#region Algorithms
func create_dsu_checker(noise_map: FastNoiseLite, height: int, width: int, constraint: float):
	return ALGORITHMS.create_dsu_checker(noise_map, height, width, constraint)

func rand_coord(width: int, height: int) -> Vector2i:
	return ALGORITHMS.rand_coord(width, height)

func rand_spread(chance: float, limit: int) -> int:
	return ALGORITHMS.rand_spread(chance, limit)

func rand_chance(chance: float) -> bool:
	return ALGORITHMS.rand_chance(chance)

func set_seed(_seed: int = 0):
	return ALGORITHMS.set_seed(_seed)

func path(start: Vector2i, goal: Vector2i, walls: Array, width: int, height: int, visited: Array = []):
	return ALGORITHMS.path(start, goal, walls, width, height, visited)
#endregion

#region UIElements
func show_text_choice(speaker: String, prompt: String, choices: Array = ['Yes', 'No'], screen_side: String = 'L', dialogue: bool = false) -> int:
	return await UI.show_text_choice(speaker, prompt, choices, screen_side, dialogue)

func show_text_box(speaker: String, prompt: String, persist: bool = false, screen_side: String = 'L', dialogue: bool = false) -> void:
	await UI.show_text_box(speaker, prompt, persist, screen_side, dialogue)

func show_confirmation_box(prompt: String):
	return await UI.show_confirmation_box(prompt)

func change_background(texture: Texture2D, global: bool = false):
	return UI.change_background(texture, global)

func show_description(object: Resource) -> void:
	return UI.show_description(object)

func show_shop_menu(stock: ResourceGroup):
	return UI.show_shop_menu(stock)

func add_text_log_to_scene():
	return UI.add_text_log_to_scene()

#endregion

#region SceneLoader
func warp(source: Location, destination_scene: PackedScene):
	return await SCENE_LOADER.warp(source, destination_scene)

func load_main_menu():
	return SCENE_LOADER.load_main_menu()

func move_node_to_other_node(node: Node, parent: Node, other_node: Node, after: int = false):
	return SCENE_LOADER.move_node_to_other_node(node, parent, other_node, after)

func push_back_player(centre: Vector2, distance: float):
	return SCENE_LOADER.push_back_player(centre, distance)
#endregion

#region Quests
func add_quest(quest: GlobalQuests.Quest):
	return QUESTS.add_quest(quest)

func set_active_quest(quest: GlobalQuests.Quest, update: bool = true):
	return QUESTS.set_active_quest(quest, update)

func update_quests():
	return QUESTS.update_quests()
#endregion

## FUNCTON TESTS
func rand_spread_test():
	var n
	for i in 1000:
		n = rand_spread(0.5, 4)
		if n > 4:
			print(n)


## SIGNALS
func _on_option_selected(index: int):
	textbox_response = index

func _confirmation_box_confirmed():
	confrimation_response = true
	confirmation_box_triggered.emit()

func _confirmation_box_canceled():
	confrimation_response = false
	confirmation_box_triggered.emit()

func _on_shop_exit():
	sell.emit('exit')
	exit_signal.emit()


func _on_textbox_skip_selected():
	var confirm = await show_confirmation_box('Skip cutscene')
	if confirm:
		textbox_skip_flag = true
		next.emit()

func _on_textbox_auto_selected(toggled_on: bool):
	if toggled_on:
		textbox_auto_flag = true
		next.emit()
	else :
		textbox_auto_flag = false
		textbox_ffwd_flag = false
		pause_timer.emit()

func _on_textbox_ffwd_selected(toggled_on: bool):
	if toggled_on:
		textbox_ffwd_flag = true
		textbox_auto_flag = true
		scroll_state = Checks.scroll
		Checks.scroll = false
		next.emit()
	else :
		textbox_ffwd_flag = false
		textbox_auto_flag = false
		Checks.state = scroll_state
		pause_timer.emit()

func _on_textbox_log_selected(toggled_on: bool):
	text_box.auto_button.disabled = toggled_on
	text_box.ffwd_button.disabled = toggled_on
	if toggled_on:
		textbox_auto_flag = false
		textbox_ffwd_flag = false

		text_box.title_container.hide()
		text_box.text_box.hide()

		text_log.show()
	else :
		text_box.title_container.show()
		text_box.text_box.show()

		text_log.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		sell.emit('exit')
		exit_signal.emit()
