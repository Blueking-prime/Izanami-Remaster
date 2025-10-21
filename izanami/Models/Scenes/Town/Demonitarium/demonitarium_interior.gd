extends Location

class_name Demonitarium

@export var counter: DemonitariumCounter

func connect_signals():
	if not Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.connect(_check_building)

func disconnect_signals():
	if Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.disconnect(_check_building)

func _check_building(node: Variant):
	overlay.hide()
	match node:
		counter: await counter.main()

func reset_from_battle():
	super.reset_from_battle()
	counter.fights.reset_from_battle()

func save() -> DemonitariumSaveData:
	var save_data: DemonitariumSaveData = DemonitariumSaveData.new()

	save_data.demonitarium_stock = counter.fights.stock

	return save_data

func load_data(data: DemonitariumSaveData):
	counter.fights.stock = data.demonitarium_stock

	print('Demonitarium Data Loaded')
