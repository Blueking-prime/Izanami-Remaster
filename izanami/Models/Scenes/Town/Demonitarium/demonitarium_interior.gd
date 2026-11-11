extends Location

class_name Demonitarium

@export var fight_counter: DemonitariumCounter
@export var skill_counter: DemonitariumCounter

func connect_signals():
	if not Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.connect(_check_building)

func disconnect_signals():
	if Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.disconnect(_check_building)

func _check_building(node: Variant):
	overlay.disable()
	match node:
		fight_counter: await fight_counter.main()
		skill_counter: await skill_counter.main()

func reset_from_battle():
	show()
	super.reset_from_battle()
	overlay.disable()
	LoadingScreen.hide()
	fight_counter.shop.reset_from_battle()


func save() -> DemonitariumSaveData:
	var save_data: DemonitariumSaveData = DemonitariumSaveData.new()

	save_data.demonitarium_stock = fight_counter.shop.stock

	return save_data

func load_data(data: DemonitariumSaveData):
	fight_counter.shop.stock = data.demonitarium_stock

	print('Demonitarium Data Loaded')
