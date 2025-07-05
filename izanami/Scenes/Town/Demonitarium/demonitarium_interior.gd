extends Location

class_name Demonitarium

@export var counter: DemonitariumCounter
@export var warp_points: Node2D

func load_scene():
	super.load_scene()

	if not Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.connect(_check_building)

func _check_building(node: Variant):
	overlay.hide()
	match node:
		counter: await counter.main()
		warp_points: await warp_points.main()


func save() -> DemonitariumSaveData:
	var save_data: DemonitariumSaveData = DemonitariumSaveData.new()

	save_data.demonitarium_stock = counter.fights.stock

	return save_data

func load_data(data: DemonitariumSaveData):
	counter.fights.stock = data.demonitarium_stock

	print('Demonitarium Data Loaded')
