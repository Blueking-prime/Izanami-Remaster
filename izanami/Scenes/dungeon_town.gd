extends Node

@onready var players: Party = get_parent().players

var dungeon: Dungeon

@export var dungeon_1_enemies: ResourceGroup
@export var dungeon_1_item_drops: ResourceGroup
@export var dungeon_1_gear_drops: ResourceGroup

@export var dungeon_2_enemies: ResourceGroup
@export var dungeon_2_item_drops: ResourceGroup
@export var dungeon_2_gear_drops: ResourceGroup

@export var dungeon_3_enemies: ResourceGroup
@export var dungeon_3_item_drops: ResourceGroup
@export var dungeon_3_gear_drops: ResourceGroup

@export var dungeon_4_enemies: ResourceGroup
@export var dungeon_4_item_drops: ResourceGroup
@export var dungeon_4_gear_drops: ResourceGroup

@export var dungeon_5_enemies: ResourceGroup
@export var dungeon_5_item_drops: ResourceGroup
@export var dungeon_5_gear_drops: ResourceGroup


func main():
	players.freeze()

	await Global.show_text_box('System', "You are travelling to Dungeon Level %d" % [players.dungeon_level])
	var confirm = await Global.show_text_choice("System", "Confirm: ")

	players.unfreeze()
	if confirm:
		dungeon = Global.dungeon_scene.instantiate()
		set_dungeon_level()
		load_dungeon()

func set_dungeon_level():
	match players.dungeon_level:
		1:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_1_enemies
			dungeon.item_drop_group = dungeon_1_item_drops
			dungeon.gear_drop_group = dungeon_1_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.nemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		2:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_2_enemies
			dungeon.item_drop_group = dungeon_2_item_drops
			dungeon.gear_drop_group = dungeon_2_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.nemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		3:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_3_enemies
			dungeon.item_drop_group = dungeon_3_item_drops
			dungeon.gear_drop_group = dungeon_3_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.nemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		4:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_4_enemies
			dungeon.item_drop_group = dungeon_4_item_drops
			dungeon.gear_drop_group = dungeon_4_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.nemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		5:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_5_enemies
			dungeon.item_drop_group = dungeon_5_item_drops
			dungeon.gear_drop_group = dungeon_5_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.nemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
			#Trigger final event
		_:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_5_enemies
			dungeon.item_drop_group = dungeon_5_item_drops
			dungeon.gear_drop_group = dungeon_5_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.nemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
	return

func load_dungeon():
	# Add dungeon to scene
	pass

# Figure out howto load this after floor four
#battle(players, [enemy_models.Gigas()])
