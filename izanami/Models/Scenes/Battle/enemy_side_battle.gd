extends Node2D

class_name BattleEnemies

@export var enemy_section: HBoxContainer
@export var battle_sprite_scene: PackedScene

@onready var no_of_enemies: int = get_parent().no_of_enemies
@onready var enemy_level: int = get_parent().enemy_level
@onready var enemy_group: ResourceGroup  = get_parent().enemy_group
@onready var enemy_set: Array = get_parent().enemy_set

var enemies: Array = []
var sprites = []

func load_enemies() -> void:
	for i in enemy_section.get_children():
		enemy_section.remove_child(i)
		if is_instance_valid(i):
			i.queue_free()

	if len(enemy_set):
		_initialize_enemies(false)
	elif enemy_group:
		_initialize_enemies(true)

	place_charscters()


func _initialize_enemies(from_resource_group: bool):
	#Spawn enemies here
	if from_resource_group:
		enemy_set = enemy_group.load_all()

	var _type
	for i in no_of_enemies:
		_type = randi_range(0, enemy_set.size() - 1)
		var enemy: Enemy = enemy_set[_type].instantiate()
		enemy.lvl = enemy_level

		add_child(enemy)

	enemies = get_children()
	#for i in enemies.size():
		#enemies[i].name = enemies[i].get_class() + ' ' + str(i)

func place_charscters():
	for i in enemies:
		var sprite: BattleSprite = battle_sprite_scene.instantiate()

		sprite.sp_bar.hide()

		i.assign_ui_element_to_character(sprite)
		enemy_section.add_child(sprite)

		i.battle_display()
