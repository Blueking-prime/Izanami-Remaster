extends Node


class_name GlobalAlgorithms


func rand_coord(width: int, height: int) -> Vector2i:
	return Vector2i(randi_range(0, width - 1), randi_range(0, height - 1))


func rand_spread(chance: float, limit: int) -> int:
	var n = 0
	while randf() < chance and n < limit:
		n += 1
	return n


func rand_chance(chance: float) -> bool:
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
