extends Node

class_name Battle

## CUSTOM PARAMETERS
@export var no_of_enemies: int
@export var enemy_level: int = 1
@export var enemy_group: ResourceGroup
@export var enemy_set: Array
@export var players: Party
@export var enemies: BattleEnemies

## CHILD NODES
@export var setup: BattleSetup
@export var process_input: BattleInput
@export var process_turns: BattleTurns
@export var process_actions: BattleActions

var earned_exp: int
var earned_gold: int

## RETURN LOCATIONS
var dungeon: Dungeon
var town: Town
var demonitarium: Node


func _ready() -> void:
	setup.actor_setup()
	#print(turn_order)
	process_turns.act()
