extends Node2D

class_name TownDungeon

@export var no_of_floors: int

@export var dungeon_title: String
@export var dungeon_dimensions: Array[Vector2]
@export var dungeon_fixed: Array[bool]
@export var dungeon_data: Array[DungeonSaveData]
@export var dungeon_enemies: Array[ResourceGroup]
@export var dungeon_levels: Array[int]
@export var dungeon_item_drops: Array[ResourceGroup]
@export var dungeon_gear_drops: Array[ResourceGroup]
@export var dungeon_MAX_ENEMIES: Array[int]
@export var dungeon_enemy_spawn_chance: Array[float]
@export var dungeon_treasure_spawn_chance: Array[float]
@export var dungeon_gear_chance: Array[float]

var dungeon: Dungeon
var dungeon_floor: int

func main():
	Global.players.freeze()
	Global.exit_button.show()

	if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)

	var choices = []
	for i in Checks.dungeons[dungeon_title.to_lower()].level:
		choices.append(str(i + 1))

	dungeon_floor = await Global.show_text_choice('System', 'Select dungeon floor', choices)

	var confirm = await Global.show_confirmation_box("Confirm: ")

	Global.players.unfreeze()
	if confirm:
		await LoadingScreen.show()
		dungeon = Global.dungeon_scene.instantiate()
		set_dungeon_level()
		load_dungeon()
		get_parent().queue_free()
	else :
		_on_exit_button_pressed()

func set_dungeon_level():
	if dungeon_floor < no_of_floors:
		if dungeon_fixed[dungeon_floor]:
			dungeon.load_data(dungeon_data[dungeon_floor])
		else:
			dungeon.width = dungeon_dimensions[dungeon_floor].x
			dungeon.height = dungeon_dimensions[dungeon_floor].y
			dungeon.enemy_types = dungeon_enemies[dungeon_floor]
			dungeon.item_drop_group = dungeon_item_drops[dungeon_floor]
			dungeon.gear_drop_group = dungeon_gear_drops[dungeon_floor]
			dungeon.MAX_ENEMIES = dungeon_MAX_ENEMIES[dungeon_floor]
			dungeon.enemy_spawn_chance = dungeon_enemy_spawn_chance[dungeon_floor]
			dungeon.treasure_spawn_chance = dungeon_treasure_spawn_chance[dungeon_floor]
			dungeon.gear_chance = dungeon_gear_chance[dungeon_floor]
	else:
		dungeon.width = 8
		dungeon.height = 5
		dungeon.enemy_types = dungeon_enemies[no_of_floors - 1]
		dungeon.item_drop_group = dungeon_item_drops[no_of_floors - 1]
		dungeon.gear_drop_group = dungeon_gear_drops[no_of_floors - 1]
		dungeon.MAX_ENEMIES = 4
		dungeon.enemy_spawn_chance = 0.8
		dungeon.treasure_spawn_chance = 0.2
		dungeon.gear_chance = 0.5
	return

func load_dungeon():
	get_parent().disconnect_signals()
	get_parent().remove_players()
	dungeon.add_players()
	get_parent().add_sibling(dungeon)
	get_tree().current_scene = dungeon
	dungeon.connect_signals()

func _on_exit_button_pressed():
	if is_instance_valid(Global.text_box):
		Global.text_box.queue_free()
	Global.exit_signal.disconnect(_on_exit_button_pressed)
	Global.exit_button.hide()
	Global.players.unfreeze()
	get_parent().overlay.show()
