extends Node

class_name Battle

## CUSTOM PARAMETERS
@export var no_of_enemies: int
@export var enemy_level: int = 1
@export var forced: bool = false
@export var enemy_group: ResourceGroup
@export var enemy_set: Array
@export var test_players: Party
@export var enemies: BattleEnemies

## CHILD NODES
@export var setup: BattleSetup
@export var process_input: BattleInput
@export var process_turns: BattleTurns
@export var process_actions: BattleActions
@export var canvas_layer: CanvasLayer

var earned_exp: int
var earned_gold: int

## RETURN LOCATIONS
var dungeon: Dungeon
var town: Town
var demonitarium: Node


func _ready() -> void:
	if Global.players:
		if is_instance_valid(test_players):
			remove_child(test_players)
			test_players.queue_free()
	else :
		Global.players =test_players

	setup.actor_setup()
	#print(turn_order)
	process_turns.act()
