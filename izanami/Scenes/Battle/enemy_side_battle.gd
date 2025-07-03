extends Node2D

class_name BattleEnemies

@export var enemy_section: Control
@export var battle_sprite_scene: PackedScene

@onready var no_of_enemies: int = get_parent().no_of_enemies
@onready var enemy_level: int = get_parent().enemy_level
@onready var enemy_group: ResourceGroup  = get_parent().enemy_group
@onready var enemy_set: Array = get_parent().enemy_set

var enemies: Array = []
var sprites = []

func load_enemies() -> void:
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

		sprite.battle_sprite.texture = i.battle_sprite_texture.texture
		sprite.nametag.text = i.battle_sprite.nametag.text
		sprite.hp_bar_text.text = str(i.hp) + ' / ' + str(i.max_hp)

		i.status_icons = sprite.status_icons
		i.nametag = sprite.nametag
		i.hp_bar = sprite.hp_bar
		i.hp_bar_text = sprite.hp_bar_text
		i.pointer = sprite.pointer
		i.indicator = sprite.indicator
		i.battle_sprite_texture = sprite.battle_sprite

		sprite.sp_bar.hide()

		i.battle_sprite = sprite

		enemy_section.add_child(sprite)

		i.battle_display()



## UNUSED ALGORITHMS
	#var screen_size = get_viewport_rect().size
	##print(screen_size)
	#screen_size.x /= 2
	#screen_size.y /= 2
	#var enemies_size = enemies.size()
	#var x_coord
	#var y_coord
	#var hor_offset = screen_size.x * 0.2 #(1 / enemies_size)
	##for i in enemies_size:
		##x_coord = round(screen_size.x * .1 * enemies[i].ally)
		##if x_coord < 0:
			##x_coord = screen_size.x + x_coord
		##y_coord = round(((screen_size.y / enemies_size) * i) + vert_offset)
#
		##var vert_offset = screen_size.y * 0.1 #(1 / enemies_size)
#
	#for i in enemies_size:
		#y_coord = round(screen_size.y * .5 )
		#x_coord = round(((screen_size.x / enemies_size) * i) + hor_offset) * enemies[i].ally
		#if x_coord < 0:
			#x_coord = screen_size.x + x_coord
#
		#enemies[i].position = Vector2(x_coord + screen_size.x, y_coord)
		##print(enemies[i].name, enemies[i].position)

	#enemy_sprites.reverse()
	#enemies.reverse()
