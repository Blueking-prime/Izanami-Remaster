extends Node2D

@export var enemy_section: Control
@export var battle_sprite_scene: PackedScene

@onready var no_of_enemies: int = get_parent().no_of_enemies
@onready var enemy_group: ResourceGroup  = get_parent().enemy_group

var enemies: Array = []
var _enemy_set = []
var sprites = []

func _ready() -> void:
	_initialize_enemies()
	place_charscters()


func _initialize_enemies():
	#Spawn enemies here
	_enemy_set = enemy_group.load_all()
	#print(_enemy_set)

	var _type
	for i in no_of_enemies:
		_type = randi_range(0, _enemy_set.size() - 1)
		add_child(_enemy_set[_type].instantiate())

	enemies = get_children()
	#for i in enemies.size():
		#enemies[i].name = enemies[i].get_class() + ' ' + str(i)

func place_charscters():
	for i in enemies:
		var sprite: BattleSprite = battle_sprite_scene.instantiate()

		sprite.battle_sprite.texture = i.battle_sprite.battle_sprite.texture
		sprite.nametag.text = i.battle_sprite.nametag.text
		sprite.hp_bar_text.text = str(i.hp) + '/' + str(i.max_hp)
		sprite.sp_bar.hide()

		enemy_section.add_child(sprite)
		i.battle_sprite = sprite
		sprites.append(sprite)

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
