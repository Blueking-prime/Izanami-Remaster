extends Node

@onready var text_box_scene: PackedScene = preload("res://Models/Menus/text_box.tscn")

var textbox_response: int

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


func dialog_choice(prompt: String, _back = true, choices: Array[String] = ['Yes', 'No']) -> int:
	var text_box = text_box_scene.instantiate()
	print(text_box)

	get_tree().get_current_scene().add_sibling(text_box)

	var _title: Label = text_box.get_node("Margin/VBox/Title")
	var text: Label = text_box.get_node("Margin/VBox/Text")
	var options: ItemList = text_box.get_node("Margin/VBox/Options")

	text.text = prompt

	options.clear()
	for i in choices:
		options.add_item(i)

	options.item_activated.connect(_on_option_selected)
	options.grab_focus()
	await options.item_activated

	text_box.queue_free()

	return textbox_response


func dialog_choice_shop(_prompt: String, _choices: Dictionary):
	#if len(choices) == 0:
		#return -1
	#while true:
		#try:
			#print('')
			#print(prompt)
			#print('S/N - Name : Cost')
			#for i, j in enumerate(choices.keys(), 1):
				#print(f'{i} - {j} : {choices[j]}')
			#print('0 - back')
#
			#x = int(input('? '))
			#if x not in range(0, len(choices) + 1):
				#print('Invalid option!')
				#continue
#
			#if x == 0:
				#return -1
#
			#return Array(choices.keys())[x - 1]
		#except ValueError:
			#print('Invalid option!')
			#continue
	pass


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
