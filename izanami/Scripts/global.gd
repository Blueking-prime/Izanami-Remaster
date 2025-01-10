extends Node

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

func dialog_choice(_prompt: String, _back = true, _choices: Array[String] = ['Yes', 'No']):
	#low_limit = 1
	#if len(choices) == 0:
		#return -1
	#while true:
		#try:
			#print('')
			#print(prompt)
#
			#Stringuctured_choices = {j: i for i, j in enumerate(choices, 1)}
			#filtered_choices = [i for i in choices if i]
#
			#for i, j in enumerate(filtered_choices, 1):
				#print(f'{i} - {j}')
			#if back:
				#print('0 - back')
				#low_limit = 0
#
			#x = int(input('? '))
			#if x not in range(low_limit, len(filtered_choices) + 1):
				#print('Invalid option!')
				#continue
#
			#if choices == ['Yes', 'No']:
				#if x == 1:
					#return true
				#if x == 2:
					#return false
			#else:
				#if x == 0:
					#return -1
#
				#choice = filtered_choices[x - 1]
				#x = Stringuctured_choices[choice]
				#return x
#
		#except ValueError:
			#print('Invalid option!')
			#continue
	pass

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
