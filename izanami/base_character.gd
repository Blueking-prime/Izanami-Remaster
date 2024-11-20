extends CharacterBody2D

# CHARACTER STATS
@export var character_name: String = ''
var base_stats: Dictionary = {"STR": 1, "INT": 1, "WIS": 1, "END": 1, "GUI": 1, "AGI": 1}
@export var hp: int = max_hp()
@export var ATK: int = 1
@export var DEF: int = 1
@export var status_effect: StringName = 'null'
@export var alive: bool = true
@export var lvl: int = 1
@export var skills: ItemList = null
@export var stats: Dictionary = base_stats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#var input_direction = Vector2()
	pass

func max_hp() -> int:
	return (base_stats['END'] * 10) + (base_stats['WIS'] * 3) + (lvl * 15)

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
	if hp > max_hp():
		hp = max_hp()

func status():
	if status_effect == 'Toxin':
		damage(max_hp() / 7)

func die():
	print('%s is dead' % [character_name])
	alive = false
