extends Node

@onready var players: Party = get_parent().players

@onready var overlay: UIOverlay = get_parent().overlay

var dungeon: Dungeon

@export var no_of_floors: int

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

func main():
	players.freeze()

	await Global.show_text_box('System', "You are travelling to Dungeon Level %s" % [str(players.dungeon_level) if players.dungeon_level < no_of_floors else 'Endless'])
	var confirm = await Global.show_text_choice("System", "Confirm: ")

	players.unfreeze()
	if confirm == 0:
		Global.change_background(Global.loading_screen, true)
		dungeon = Global.dungeon_scene.instantiate()
		dungeon.players = players
		set_dungeon_level()
		load_dungeon()
		get_parent().queue_free()
	else :
		overlay.show()

func set_dungeon_level():
	if players.dungeon_level < no_of_floors:
		if dungeon_fixed[players.dungeon_level]:
			dungeon.load_data(dungeon_data[players.dungeon_level])
		else:
			dungeon.width = dungeon_dimensions[players.dungeon_level].x
			dungeon.height = dungeon_dimensions[players.dungeon_level].y
			dungeon.enemy_types = dungeon_enemies[players.dungeon_level]
			dungeon.item_drop_group = dungeon_item_drops[players.dungeon_level]
			dungeon.gear_drop_group = dungeon_gear_drops[players.dungeon_level]
			dungeon.MAX_ENEMIES = dungeon_MAX_ENEMIES[players.dungeon_level]
			dungeon.enemy_spawn_chance = dungeon_enemy_spawn_chance[players.dungeon_level]
			dungeon.treasure_spawn_chance = dungeon_treasure_spawn_chance[players.dungeon_level]
			dungeon.gear_chance = dungeon_gear_chance[players.dungeon_level]
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
	get_parent().remove_child(players)
	dungeon.get_node('ObjectsSort').add_child(players)
	get_parent().add_sibling(dungeon)
	get_tree().current_scene = dungeon

# Figure out howto load this after floor four
#battle(players, [enemy_models.Gigas()])
