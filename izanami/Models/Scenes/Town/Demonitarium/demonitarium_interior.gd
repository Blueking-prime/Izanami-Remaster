extends Location

class_name Demonitarium

@export var fight_counter: DemonitariumCounter
@export var skill_counter: DemonitariumCounter

@export var regent_area: StaticBody2D
@export var beatrix_npc: NPC
@export var momiji_npc: NPC
@export var regent_npc: NPC
@export var giles_npc: NPC
@export var micah_npc: NPC

func _check_building(node: Variant):
	super._check_building(node)
	match node:
		fight_counter: await fight_counter.main()
		skill_counter: await skill_counter.main()

func reset_from_battle():
	show()
	super.reset_from_battle()
	overlay.disable()
	LoadingScreen.hide()
	fight_counter.shop.reset_from_battle()

func _begin():
	momiji_npc.hide()
	beatrix_npc.hide()

func _post_west_tower():
	super._post_west_tower()
	if Checks.check_flags(['beatrix_saved']):
		beatrix_npc.show()
	if Checks.check_flags(['beatrix_in_party']):
		beatrix_npc.hide()

func _post_east_tower():
	super._post_east_tower()
	momiji_npc.show()
	if Checks.check_flags(['momiji_in_party']):
		momiji_npc.hide()

	regent_area.hide()


func save() -> DemonitariumSaveData:
	var save_data: DemonitariumSaveData = DemonitariumSaveData.new()

	save_data.demonitarium_stock = fight_counter.shop.stock

	return save_data

func load_data(data: DemonitariumSaveData):
	fight_counter.shop.stock = data.demonitarium_stock

	print('Demonitarium Data Loaded')
