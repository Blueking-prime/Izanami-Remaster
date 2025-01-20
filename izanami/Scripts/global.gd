extends Node

@onready var text_box_scene: PackedScene = preload("res://Models/Menus/text_box.tscn")
@onready var description_box_scene: PackedScene = preload("res://Models/Menus/description_box.tscn")
@onready var shop_menu_scene: PackedScene = preload("res://Scenes/shop_menu.tscn")

var textbox_response: int
var description_box_parent: Node
var description_box: Node
var shop_menu: Node

signal next

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


func dialog_choice(speaker: String, prompt: String, choices: Array[String] = ['Yes', 'No']) -> int:
	var text_box: Control = text_box_scene.instantiate()
	print(text_box)

	get_tree().get_current_scene().add_sibling(text_box)

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


func show_text_box(speaker: String, prompt: String) -> void:
	var text_box: Control = text_box_scene.instantiate()
	print(text_box)

	get_tree().get_current_scene().add_sibling(text_box)

	print(get_tree().get_current_scene())

	var title: Label = text_box.get_node("Margin/VBox/Title")
	var text: Label = text_box.get_node("Margin/VBox/Text")
	text_box.get_node("Margin/VBox/Options").hide()
	text_box.get_node("Margin/VBox/Control").hide()

	title.text = speaker
	text.text = prompt

	await next

	print("We have awaited")

	text_box.queue_free()


func show_description(object: Resource) -> void:
	description_box = description_box_scene.instantiate()

	if description_box_parent:
		description_box_parent.add_child(description_box)
	else:
		get_tree().get_current_scene().add_child(description_box)

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
			weapon_status.text = 'Equipped'
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
	element.text = object.element
	description.text = object.desc


func dialog_choice_shop(players: Party, stock: ResourceGroup):
	shop_menu = shop_menu_scene.instantiate()

	get_tree().get_current_scene().add_sibling(shop_menu)

	var shop_inventory_pane: ItemList = shop_menu.get_node("CanvasLayer/HBoxContainer/ShopInventory")
	var player_inventory_pane: ItemList = shop_menu.get_node("CanvasLayer/HBoxContainer/PlayerInventory")

	shop_inventory_pane.item_group = stock
	player_inventory_pane.players = players

	shop_inventory_pane.load_stock()
	player_inventory_pane.load_stock()


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

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		print('Enter pressed')
		next.emit()
	elif event.is_action_pressed("click"):
		print('Mouse Clicked')
		next.emit()
