extends Node

class_name GlobalAlgorithms

class DSU:
	"""An implementation of the Disjoint Set Union data structure.
		Works like kinda like a linked Array"""
	var height: int
	var width: int
	var parent: Array

	func _init(_width: int, _height: int):
		self.height = _height
		self.width = _width

		# Initialize each node to be its own parent
		self.parent = range(width * height)

	func find(i) -> int:
		# Trace parents to find root parent
		if self.parent[i] == i:
			return i
		self.parent[i] = self.find(self.parent[i])
		return self.parent[i]

	func union(i, j):
		# point the parent root parent of i to the root parent of j
		var root_i = self.find(i)
		var root_j = self.find(j)

		if root_i != root_j:
			self.parent[root_i] = root_j

func create_dsu_checker(noise_map: FastNoiseLite, height: int, width: int):
	"""Processes the grid and returns a function to check connectivity."""
	if not noise_map: return

	var dsu: DSU = DSU.new(width, height)

	# Step 1: Pre-process the noise_map to union all adjacent open spaces
	for y in range(height):
		for x in range(width):
			if noise_map.get_noise_2d(x, y) >= 0:
				var index1 = y * width + x
				# Union with the node to the yight
				if x + 1 < width and noise_map.get_noise_2d(x + 1, y) >= 0:
					var index2 = y * width + (x + 1)
					dsu.union(index1, index2)
				# Union with the node below
				if y + 1 < height and noise_map.get_noise_2d(x, y + 1) >= 0:
					var index2 = (y + 1) * width + x
					dsu.union(index1, index2)

	# Step 2: Return a fast checker function
	var checker: Callable = func (start: Vector2i, end: Vector2i, cutoff: float = 0):
		if (noise_map.get_noise_2dv(start) < cutoff) or (noise_map.get_noise_2dv(end) < cutoff):
			return false
		var start_index = start.y * width + start.x
		var end_index = end.y * width + end.x
		return dsu.find(start_index) == dsu.find(end_index)

	get_parent().path_checker = checker

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

func set_seed(_seed: int = 0):
	if not _seed:
		if is_instance_valid(get_parent().players):
			for i in get_parent().players.leader.character_name:
				i = i as String
				_seed *= i.unicode_at(0)
		else :
			_seed = Time.get_ticks_usec()
	seed(_seed)
	Checks.custom_seed = _seed


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
