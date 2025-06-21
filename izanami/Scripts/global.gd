extends Node

@export var text_box_scene: PackedScene
@export var confirmation_box_scene: PackedScene
@export var description_box_scene: PackedScene
@export var shop_menu_scene: PackedScene
@export var text_log_scene: PackedScene

@export var town_scene: PackedScene
@export var dungeon_scene: PackedScene
@export var demonitarium_scene: PackedScene
@export var battle_scene: PackedScene
@export var main_menu_scene: PackedScene

@export var loading_screen: AnimatedTexture

var players: Party

var input_type: int
var dialog_text_log: String

var description_box_parent: Node
var description_box: DescriptionBox
var background_texture: TextureRect
var shop_menu: Control
var text_box: TextBox
var action_log: Label
var confirmation_box: ConfirmationDialog

var textbox_response: int
var confrimation_response: bool

var textbox_skip_flag: bool
var textbox_auto_flag: bool
var textbox_ffwd_flag: bool

var text_log: TextLog

signal next
signal pause_timer
signal confirmation_box_triggered
signal sell(condition)


## ALGORITHMS
func rand_coord(width: int, height: int) -> Vector2i:
	return Vector2i(randi_range(0, width - 1), randi_range(0, height - 1))


func rand_spread(chance: float, limit: int):
	var n = 0
	while randf() < chance and n < limit:
		n += 1
	return n


func rand_chance(chance: float):
	if randf() < chance:
		return true
	else:
		return false


func path(start: Vector2i, goal: Vector2i, walls: Array, width: int, height: int, visited: Array = []):

	if start in walls:
		return false

	var l = start + Vector2i.LEFT
	var r = start + Vector2i.RIGHT
	var u = start + Vector2i.UP
	var d = start + Vector2i.DOWN

	# Check if goal is next to path
	if start == goal or u == goal or d == goal or l == goal or r == goal:
		return true


	# If (x,y) is a valid node
	if (start.y >= 0 and start.y < height) and (start.x >= 0 and start.x < width):
		if start in visited:
			return false
		else:
			visited.append(start)

	# Recurse through all adjacent points
		var up    = path(u, goal, walls, width, height, visited)
		if up:
			return true

		var left  = path(l, goal, walls, width, height, visited)
		if left:
			return true

		var down  = path(d, goal, walls, width, height, visited)
		if down:
			return true

		var right = path(r, goal, walls, width, height, visited)
		if right:
			return true

	return false


## UI ELEMENTS
func show_text_choice(speaker: String, prompt: String, choices: Array = ['Yes', 'No'], screen_side: String = 'L', scroll: bool = true, dialogue: bool = false) -> int:
	if is_instance_valid(text_box):
		text_box.queue_free()

	text_box = text_box_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(text_box)

	text_box.title.text = speaker
	if scroll:
		text_box.text_string = prompt
		text_box.scroll_text()
	else:
		text_box.text.text = prompt

	if not dialogue:
		text_box.button_panel.hide()

	if textbox_auto_flag:
		text_box.auto_button.set_pressed_no_signal(true)

	dialog_text_log += speaker + ': ' + prompt + '\n\n'

	match screen_side:
		'L': text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		'C': text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		'R': text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_END

	text_box.options.clear()
	for i in choices:
		text_box.options.add_item(i)

	text_box.options.grab_focus()

	connect_text_box_signals()

	Input.warp_mouse(text_box.global_position)

	await text_box.options.item_activated

	# Add choices to log and capitalize selected choice
	choices[textbox_response].to_upper()
	for i in choices:
		dialog_text_log += i + '\n\n'

	text_box.queue_free()

	return textbox_response


func show_text_box(speaker: String, prompt: String, persist: bool = false, screen_side: String = 'L', scroll: bool = true,  dialogue: bool = false) -> void:
	if is_instance_valid(text_box):
		text_box.queue_free()

	text_box = text_box_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(text_box)

	text_box.spacer.hide()
	text_box.options.hide()

	text_box.title.text = speaker

	if scroll:
		text_box.text_string = prompt
		text_box.scroll_text()
	else:
		text_box.text.text = prompt

	dialog_text_log += speaker + ': ' + prompt

	match screen_side:
		'L': text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		'C': text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		'R': text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_END

	if textbox_auto_flag:
		text_box.auto_button.set_pressed_no_signal(true)

	if not dialogue:
		text_box.button_panel.hide()

	connect_text_box_signals()

	Input.warp_mouse(text_box.global_position)

	if not persist:
		await next
		text_box.queue_free()

func connect_text_box_signals():
	text_box.options.item_activated.connect(_on_option_selected)

	if text_box.button_panel.visible:
		text_box.auto_button.toggled.connect(_on_textbox_auto_selected)
		text_box.ffwd_button.toggled.connect(_on_textbox_ffwd_selected)
		text_box.log_button.toggled.connect(_on_textbox_log_selected)
		text_box.skip_button.pressed.connect(_on_textbox_skip_selected)


func show_confirmation_box(prompt: String):
	if is_instance_valid(confirmation_box):
		confirmation_box.queue_free()

	confirmation_box = confirmation_box_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(confirmation_box)

	confirmation_box.dialog_text = prompt
	confirmation_box.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	confirmation_box.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	confirmation_box.canceled.connect(_confirmation_box_canceled)
	confirmation_box.confirmed.connect(_confirmation_box_confirmed)

	await confirmation_box_triggered

	return confrimation_response



func change_background(texture: Texture2D, global: bool = false):
	if texture:
		if not is_instance_valid(background_texture):
			background_texture = TextureRect.new()
			background_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			background_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
			if not global:
				get_tree().current_scene.canvas_layer.get_child(0).add_sibling(background_texture)
			else:
				get_tree().root.add_child(background_texture)

		background_texture.texture = texture
	else:
		if is_instance_valid(background_texture):
			if not global:
				get_tree().current_scene.canvas_layer.remove_child(background_texture)
			else :
				get_tree().root.remove_child(background_texture)
			background_texture.queue_free()


func add_to_text_log(dialogue: Array):
	if not text_log:
		text_log = text_log_scene.instantiate()
	text_log.label.append_text(dialogue[0] + '\n')
	text_log.label.push_indent(1)
	text_log.label.append_text(dialogue[1] + '\n')
	if dialogue.size() >= 3:
		text_log.label.push_list(1, RichTextLabel.LIST_DOTS, true)
		for i in dialogue[2]:
			text_log.label.append_text(i + '\n')
	text_log.label.pop_all()
	text_log.label.newline()


func show_description(object: Resource) -> void:
	if is_instance_valid(description_box):
		description_box.queue_free()

	description_box = description_box_scene.instantiate()

	if description_box_parent:
		description_box_parent.add_child(description_box)
	else:
		get_tree().get_current_scene().canvas_layer.add_child(description_box)

	if 'stats' in object:
		var stats_string = ''
		for i in object.stats:
			if object.stats is Dictionary:
				if object.stats[i] != 0:
					stats_string += i + ': ' + str(object.stats[i]) + ' '
			else:
				stats_string += i + ' '
		description_box.stats.text = stats_string
	else:
		description_box.stats.hide()

	description_box.cost.hide()

	if object is Gear:
		description_box.type.text = 'Gear'
		description_box.subtype.text = object.slot
		if object.equipped:
			description_box.weapon_status.show()
		description_box.effect_chance.hide()
		description_box.target_scope.hide()
		description_box.value.hide()
	else:
		if object is Item:
			description_box.type.text = 'Item'
			description_box.effect_chance.text = str(object.effect_chance * 100) + '%'
		if object is Skill:
			description_box.type.text = 'Skill'
			description_box.cost.show()
			description_box.cost.text = str(object.cost)
			description_box.effect_chance.text = str(object.effect_chance[object.rank] * 100) + '%'
			if object.rank > 0:
				description_box.rank.text = '+'.repeat(object.rank)
				description_box.rank.show()

		if object.value != 0:
			description_box.value.text = str(object.value)
		elif object.status_effect:
			description_box.value.text = object.status_effect.new().desc
		else:
			description_box.value.hide()

		description_box.subtype.text = object.type
		if object.aoe:
			description_box.target_scope.text = 'AOE'
		if object.universal:
			description_box.target_scope.text = 'Universal'
		else:
			description_box.target_scope.text = "Single"
		description_box.weapon_status.hide()

	if 'price' in object:
		description_box.sell_price.text = '#' + str(object.price)
	elif object is Skill:
		description_box.sell_price.text = str(object.crit_chance[object.rank] * 100) + '%'
	else:
		description_box.sell_price.hide()

	if 'element' in object:
		description_box.element.text = object.element
	description_box.description.text = object.desc


func show_shop_menu(_players: Party, stock: ResourceGroup):
	if is_instance_valid(shop_menu):
		shop_menu.queue_free()

	shop_menu = shop_menu_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(shop_menu)

	shop_menu.shop_inventory.item_group = stock
	shop_menu.player_inventory.players = _players

	shop_menu.exit_button.pressed.connect(_on_shop_exit)

	shop_menu.shop_inventory.load_stock()
	shop_menu.player_inventory.load_stock()


func load_main_menu():
	var main_menu = main_menu_scene.instantiate()
	get_tree().unload_current_scene()
	add_sibling(main_menu)
	get_tree().current_scene = main_menu


## GENERAL FUNCTIONS
func print_to_log(text: Variant):
	if not action_log: return

	if text is String:
		action_log.text += '\n' + text
	else :
		action_log.text += '\n' + str(text)


func warp(source: Location, destination_scene: PackedScene):
	var destination: Location = destination_scene.instantiate()
	source.add_sibling(destination)

	source.remove_players()
	destination.add_players(players)

	# Set destination as main scene
	get_tree().current_scene = destination

	# Reload destination and delete current scene
	destination.load_scene()
	source.call_deferred('queue_free')

	players.leader.global_position = destination.entrance

	print(get_tree().current_scene)

	print('Town Loaded')

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
		next.emit()
	else :
		textbox_ffwd_flag = false
		textbox_auto_flag = false
		pause_timer.emit()

func _on_textbox_log_selected(toggled_on: bool):
	if toggled_on:
		textbox_auto_flag = false
		textbox_ffwd_flag = false
		text_log.show()
	else :
		text_log.hide()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		sell.emit('exit')
