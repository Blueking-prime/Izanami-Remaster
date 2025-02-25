class_name Base_Character

extends CharacterBody2D

## CHILD NODES
@export var skills: CharacterSkills
@export var items: CharacterItems
@export var statuses: CharacterStatuses

@export var nametag: Label

@export var hp_bar: ProgressBar
@export var hp_bar_text: Label
@export var sp_bar: ProgressBar
@export var sp_bar_text: Label

@export var pointer: TextureRect
@export var indicator: TextureRect
@export var battle_sprite_texture: TextureRect

@export var battle_sprite: BattleSprite
@export var dungeon_sprite: Sprite2D
@export var hitbox: CollisionShape2D


## CHARACTER STATS
@export var character_name: String
@export var root_stats: Dictionary = {"STR": 1, "INT": 1, "WIS": 1, "END": 1, "GUI": 1, "AGI": 1}
var base_stats: Dictionary = root_stats.duplicate()
var stats: Dictionary = base_stats.duplicate()

@export var level_stats: Array = ["STR", "INT", "WIS", "END", "GUI", "AGI"]
@export var desc: String

@export var max_hp: int:
	get():
		return (stats['END'] * 10) + (stats['WIS'] * 3) + (lvl * 15)

@export var hp: int:
	set(value):
		hp = value
		#print(hp, ' ', value, ' ', max_hp)
		_update_hp_bar()

@export var ATK: float = 1
@export var DEF: float = 1
@export var alive: bool = true
@export var lvl: int = 1
@export var ally: int

var stunned: bool = false

func _ready() -> void:
	load_character()
	statuses.test()

func load_character():
	#stats = base_stats
	#print(base_stats, ' ', stats)
	update_stats()
	hp = max_hp
	#pointer.set_position(Vector2(0, -130))
	nametag.text = character_name
	skills.load_stock()
	items.load_stock()

	#if ally > 0:
		#pointer.set_texture(load("res://Assets/right_arrow.svg"))
	#else:
		#pointer.set_texture(load("res://Assets/left_arrow.svg"))
	#print(name, pointer.position)
	#print(hp)
	#print("ROOT STATS", root_stats)
	#print("BASE STATS", base_stats)
	#print("STATS", stats)
	#print(skills.get_skills())
	#print(skills.get_skills()[1].action(self, self))

func _update_hp_bar():
	if hp_bar:
		hp_bar.value = (hp / max_hp) * 100
		hp_bar_text.text = str(hp, ' / ', max_hp)

func dungeon_display():
	battle_sprite.hide()
	dungeon_sprite.show()

func battle_display():
	battle_sprite.show()
	dungeon_sprite.hide()

func set_acting():
	indicator.show()

func unset_acting():
	indicator.hide()

func target():
	pointer.show()

func untarget():
	pointer.hide()


func update_stats():
	for i in root_stats:
		if i in level_stats:
			base_stats[i] = lvl * root_stats[i]

	stats = base_stats.duplicate()


func get_skills():
	return skills.get_skills()

func use_skill(skill_id, _target):
	var skill: Skill = get_skills()[skill_id]
	skill.action(self, _target)


func get_items():
	return items.get_items()

func use_item(item_name, _target):
	var item: Item = items.get_item(item_name)
	item.use(_target)
	items.remove_item(item)


func guard():
	DEF *= 2
	print('%s braces for impact' % [character_name])

func damage(value: float):
	value /= DEF
	print('%s takes %f damage!' % [character_name, value])
	if value < hp:
		hp -= value
	else:
		hp = 0
		die()

func heal(value: float):
	hp += value
	print(' %s healed %f HP' % [character_name, value])
	if hp > max_hp:
		hp = max_hp

func die():
	print('%s is dead' % [character_name])
	alive = false

func save() -> CharacterSaveData:
	var save_data: CharacterSaveData = CharacterSaveData.new()

	save_data.hp = hp
	save_data.lvl = lvl
	save_data.alive = alive
	save_data.position = position
	save_data.scene_file_path = scene_file_path

	return save_data

func load_data(data: CharacterSaveData):
	lvl = data.lvl
	alive = data.alive

	load_character()

	hp = data.hp
	position = data.position
