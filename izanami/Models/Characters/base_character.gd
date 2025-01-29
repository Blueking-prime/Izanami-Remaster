class_name Base_Character

extends CharacterBody2D

## CHILD NODES
@onready var skills: Node = $Skills
@onready var items: Node = $Items

@export var nametag: Label

@export var hp_bar: ProgressBar
@export var hp_bar_text: Label
@export var sp_bar: ProgressBar
@export var sp_bar_text: Label

@export var pointer: TextureRect
@export var battle_sprite_texture: TextureRect

@export var battle_sprite: BattleSprite
@export var dungeon_sprite: Sprite2D
@export var hitbox: CollisionShape2D


## CHARACTER STATS
@export var character_name: String = name
var base_stats: Dictionary = {"STR": 1, "INT": 1, "WIS": 1, "END": 1, "GUI": 1, "AGI": 1}
@export var stats: Dictionary = base_stats

@export var max_hp: int:
	get():
		return (base_stats['END'] * 10) + (base_stats['WIS'] * 3) + (lvl * 15)

@export var hp: int:
	set(value):
		hp = value
		#print(hp, ' ', value, ' ', max_hp)
		_update_hp_bar()

@export var ATK: float = 1
@export var DEF: float = 1
@export var status_effect: StringName = 'null'
@export var alive: bool = true
@export var lvl: int = 1
@export var ally: int


func _ready() -> void:
	#stats = base_stats
	#print(base_stats, ' ', stats)

	hp = max_hp
	#pointer.set_position(Vector2(0, -130))
	nametag.text = name

	#if ally > 0:
		#pointer.set_texture(load("res://Assets/right_arrow.svg"))
	#else:
		#pointer.set_texture(load("res://Assets/left_arrow.svg"))
	#print(name, pointer.position)
	#print(hp)
	#print(stats)
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

func focus():
	pointer.show()

func unfocus():
	pointer.hide()


func get_skills():
	return skills.get_skills()

func use_skill(skill_id, target):
	var skill: Skill = get_skills()[skill_id]
	skill.action(self, target)


func get_items():
	return items.get_items()

func use_item(item_name, target):
	var item: Item = items.get_item(item_name)
	item.use(target)
	items.remove_item(item)


func guard():
	DEF *= 2
	print('%s braces for impact' % [name])

func damage(value: float):
	value /= DEF
	print('%s takes %f damage!' % [name, value])
	if value < hp:
		hp -= value
	else:
		hp = 0
		die()

func heal(value: float):
	hp += value
	print(' %s healed %f HP' % [name, value])
	if hp > max_hp:
		hp = max_hp

func status():
	if status_effect == 'Toxin':
		damage(max_hp / 7)

func die():
	print('%s is dead' % [name])
	alive = false
