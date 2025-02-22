extends Node

@onready var text_box_scene: PackedScene = preload("res://Models/Menus/DialogBoxes/text_box.tscn")
@onready var description_box_scene: PackedScene = preload("res://Models/Menus/DialogBoxes/description_box.tscn")
@onready var shop_menu_scene: PackedScene = preload("res://Models/Menus/ShopMenus/shop_menu.tscn")

@onready var dungeon_scene: PackedScene = preload("res://Scenes/Dungeon/dungeon.tscn")
@onready var battle_scene: PackedScene = preload("res://Scenes/Battle/battle.tscn")
@onready var town_scene: PackedScene = preload("res://Scenes/Town/town.tscn")
@onready var main_menu_scene: PackedScene = preload("res://Scenes/main_menu.tscn")

var player_party: Party

var description_box_parent: Node
var description_box: Control
var shop_menu: Control
var text_box: Control

var textbox_response: int

signal next
signal sell(condition)

## ALGORITHMS
func rand_coord(width: int, height: int):
	return [randi_range(0, width - 1), randi_range(0, height - 1)]


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


func path(start: Array, goal: Array, walls: Array, width: int, height: int, visited: Array = []):

	if start in walls:
		return false

	var x = start[0]
	var y = start[1]
	var l = [x - 1, y]
	var r = [x + 1, y]
	var u = [x, y - 1]
	var d = [x, y + 1]

	# Check if goal is next to path
	if start == goal or u == goal or d == goal or l == goal or r == goal:
		return true


	# If (x,y) is a valid node
	if (y >= 0 and y < height) and (x >= 0 and x < width):
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
func show_text_choice(speaker: String, prompt: String, choices: Array[String] = ['Yes', 'No']) -> int:
	if is_instance_valid(text_box):
		text_box.queue_free()

	text_box = text_box_scene.instantiate()

	get_tree().get_current_scene().get_child(-1).add_child(text_box)

	var title: Label = text_box.get_node("Margin/VBox/Title")
	var text: Label = text_box.get_node("Margin/VBox/Text")
	var options: ItemList = text_box.get_node("Margin/VBox/Options")

	title.text = speaker
	text.text = prompt

	options.clear()
	for i in choices:
		options.add_item(i)

	options.item_activated.connect(_on_option_selected)
	options.grab_focus()
	await options.item_activated

	text_box.queue_free()

	return textbox_response


func show_text_box(speaker: String, prompt: String, persist: bool = false) -> void:
	if is_instance_valid(text_box):
		text_box.queue_free()

	text_box = text_box_scene.instantiate()

	get_tree().get_current_scene().get_child(-1).add_child(text_box)

	var title: Label = text_box.get_node("Margin/VBox/Title")
	var text: Label = text_box.get_node("Margin/VBox/Text")
	text_box.get_node("Margin/VBox/Options").hide()
	text_box.get_node("Margin/VBox/Control").hide()

	title.text = speaker
	text.text = prompt

	if not persist:
		await next
		text_box.queue_free()


func show_description(object: Resource) -> void:
	if is_instance_valid(description_box):
		description_box.queue_free()

	description_box = description_box_scene.instantiate()

	if description_box_parent:
		description_box_parent.add_child(description_box)
	else:
		get_tree().get_current_scene().get_child(-1).add_child(description_box)

	var type: Label = description_box.get_node("Margin/Vbox/Hbox/Type")
	var element: Label = description_box.get_node("Margin/Vbox/Hbox/Element")
	var value: Label = description_box.get_node("Margin/Vbox/Hbox/Vbox/Value")
	var effect_chance: Label = description_box.get_node("Margin/Vbox/Hbox/Vbox/EffectChance")
	var description: Label = description_box.get_node("Margin/Vbox/Description")
	var subtype: Label = description_box.get_node("Margin/Vbox/Hbox2/Subtype")
	var target_scope: Label = description_box.get_node("Margin/Vbox/Hbox2/TargetScope")
	var sell_price: Label = description_box.get_node("Margin/Vbox/Hbox2/SellPrice")
	var weapon_status: Label = description_box.get_node("Margin/Vbox/Hbox2/WeaponStatus")
	var cost: Label = description_box.get_node("Margin/Vbox/Hbox2/Cost")
	var stats: Label = description_box.get_node("Margin/Vbox/Hbox/Stats")

	if 'stats' in object:
		var stats_string = ''
		for i in object.stats:
			if object.stats is Dictionary:
				if object.stats[i] != 0:
					stats_string += i + ': ' + str(object.stats[i]) + ' '
			else:
				stats_string += i + ' '
		stats.text = stats_string
	else:
		stats.hide()

	cost.hide()

	if object is Gear:
		type.text = 'Gear'
		subtype.text = object.slot
		if object.equipped:
			weapon_status.show()
		effect_chance.hide()
		target_scope.hide()
		value.hide()
	else:
		if object is Item:
			type.text = 'Item'
		if object is Skill:
			type.text = 'Skill'
			cost.show()
			cost.text = str(object.cost)

		if object.value != 0:
			value.text = str(object.value)
		elif object.status_effect:
			value.text = object.status_effect
		else:
			value.hide()

		subtype.text = object.type
		effect_chance.text = str(object.accuracy * 100) + '%'
		if object.aoe:
			target_scope.text = 'AOE'
		else:
			target_scope.text = "Single"
		weapon_status.hide()

	if 'price' in object:
		sell_price.text = '#' + str(object.price)
	elif object is Skill:
		sell_price.text = str(object.crit_chance * 100) + '%'
	else:
		sell_price.hide()

	if 'element' in object:
		element.text = object.element
	description.text = object.desc


func show_shop_menu(players: Party, stock: ResourceGroup):
	if is_instance_valid(shop_menu):
		shop_menu.queue_free()

	shop_menu = shop_menu_scene.instantiate()

	get_tree().get_current_scene().get_child(-1).add_child(shop_menu)

	var shop_inventory_pane: ShopInventoryMenu = shop_menu.get_node("CanvasLayer/ShopInventory")
	var player_inventory_pane: PlayerInventoryMenu = shop_menu.get_node("CanvasLayer/PlayerInventory")
	var exit_button: Button = shop_menu.get_node("CanvasLayer/ExitButton")

	shop_inventory_pane.item_group = stock
	player_inventory_pane.players = players

	exit_button.pressed.connect(_on_shop_exit)

	shop_inventory_pane.load_stock()
	player_inventory_pane.load_stock()


func load_main_menu():
	var main_menu = main_menu_scene.instantiate()
	get_tree().unload_current_scene()
	add_sibling(main_menu)
	get_tree().current_scene = main_menu

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

func _on_shop_exit():
	sell.emit('exit')

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		#print('Enter pressed')
		next.emit()
	elif event.is_action_pressed("click"):
		#print('Mouse Clicked')
		next.emit()
	if event.is_action_pressed("ui_cancel"):
		sell.emit('exit')
