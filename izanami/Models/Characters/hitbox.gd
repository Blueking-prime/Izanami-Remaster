extends CollisionShape2D

var target_location: Vector2
var center: Vector2
var hitcenter: bool = false
var detect_mask: Variant
var query: PhysicsShapeQueryParameters2D

func check_overlap(walls: DungeonObjects):
	detect_mask = walls
	center = walls.center()

	loop()

func loop():
	if abs(get_parent().global_position.distance_to(center)) <= 10:
		hitcenter = true

	if hitcenter:
		target_location = Vector2(0, 0)
	else:
		target_location = center

	if check():
		push_character()


func get_overlaps() -> Array:
	query = PhysicsShapeQueryParameters2D.new()
	query.collide_with_areas = true
	query.transform = global_transform
	query.shape = shape

	return get_world_2d().direct_space_state.intersect_shape(query)

func check() -> bool:
	var colliders: Array = []
	#print(get_overlaps())
	for i in get_overlaps():
		colliders.append(i.collider)
	#print(get_parent(), colliders)
	if detect_mask in colliders:
		return true
	else:
		return false

func push_character():
	var direct: Vector2 = get_parent().global_position.direction_to(target_location)
	get_parent().global_position += direct * 10

	loop()
