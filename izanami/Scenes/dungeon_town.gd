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
	if confirm == 0:
		dungeon = Global.dungeon_scene.instantiate()
		dungeon.players = players
		set_dungeon_level()
		load_dungeon()
		get_parent().queue_free()

func set_dungeon_level():
	match players.dungeon_level:
		1:
			dungeon.width = 10
			dungeon.height = 10
			dungeon.enemy_types = dungeon_1_enemies
			dungeon.item_drop_group = dungeon_1_item_drops
			dungeon.gear_drop_group = dungeon_1_gear_drops
			dungeon.MAX_ENEMIES = 1
			dungeon.enemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		2:
			dungeon.width = 15
			dungeon.height = 15
			dungeon.enemy_types = dungeon_2_enemies
			dungeon.item_drop_group = dungeon_2_item_drops
			dungeon.gear_drop_group = dungeon_2_gear_drops
			dungeon.MAX_ENEMIES = 2
			dungeon.enemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		3:
			dungeon.width = 20
			dungeon.height = 20
			dungeon.enemy_types = dungeon_3_enemies
			dungeon.item_drop_group = dungeon_3_item_drops
			dungeon.gear_drop_group = dungeon_3_gear_drops
			dungeon.MAX_ENEMIES = 3
			dungeon.enemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		4:
			dungeon.width = 25
			dungeon.height = 25
			dungeon.enemy_types = dungeon_4_enemies
			dungeon.item_drop_group = dungeon_4_item_drops
			dungeon.gear_drop_group = dungeon_4_gear_drops
			dungeon.MAX_ENEMIES = 4
			dungeon.enemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
		5:
			dungeon.width = 30
			dungeon.height = 30
			dungeon.enemy_types = dungeon_5_enemies
			dungeon.item_drop_group = dungeon_5_item_drops
			dungeon.gear_drop_group = dungeon_5_gear_drops
			dungeon.MAX_ENEMIES = 4
			dungeon.enemy_spawn_chance = 0.8
			dungeon.treasure_spawn_chance = 0.2
			dungeon.gear_chance = 0.5
			#Trigger final event
		_:
			dungeon.width = 8
			dungeon.height = 5
			dungeon.enemy_types = dungeon_5_enemies
			dungeon.item_drop_group = dungeon_5_item_drops
			dungeon.gear_drop_group = dungeon_5_gear_drops
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
