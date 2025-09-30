extends Location

class_name Town

@export var church: TownChurch
@export var smithy: TownSmithy
@export var apothecary: TownApothecary
@export var dungeon: TownDungeon
@export var demonitarium: TownDemonitarium
@export var palace: Node
@export var test: Node

var locations = ["Palace", "Church", "Smithy", "Apothecary", "Demonitorium", "Dungeon"]
var actions = ['Talk', "Go Somewhere", 'Status']
var characters = ["Kobaneko", "White"]

func load_scene():
	super.load_scene()

func connect_signals():
	if not Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.connect(_check_building)

func disconnect_signals():
	if Global.players.leader.detector.hit_building.is_connected(_check_building):
		Global.players.leader.detector.hit_building.disconnect(_check_building)

func _check_building(node: Variant):
	overlay.hide()
	match node:
		church: await church.main()
		dungeon: await dungeon.main()
		smithy: await smithy.main()
		apothecary: await apothecary.main()
		demonitarium: await demonitarium.main()
		palace: await palace.main()
		test: await test.main()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_end"):
		#func_church()

func save() -> TownSaveData:
	var save_data: TownSaveData = TownSaveData.new()

	save_data.apothecary_stock = apothecary.stock
	save_data.smithy_stock = smithy.stock

	return save_data

func load_data(data: TownSaveData):
	apothecary.stock = data.apothecary_stock
	smithy.stock = data.smithy_stock

	print('Town Data Loaded')


func _on_entrance_body_entered(_body: Node2D) -> void:
	Global.players.freeze()
	if await Global.show_confirmation_box('Go to overworld?'):
		print('Entrance')
		go_to_overworld()
	else :
		Global.players.unfreeze()
