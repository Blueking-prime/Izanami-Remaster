class_name Base_Character

extends CharacterBody2D

# CHARACTER STATS
@export var character_name: String = name
var base_stats: Dictionary = {"STR": 1, "INT": 1, "WIS": 1, "END": 1, "GUI": 1, "AGI": 1}
@export var stats: Dictionary = base_stats

@export var max_hp: float:
	get():
		return (base_stats['END'] * 10) + (base_stats['WIS'] * 3) + (lvl * 15)

@export var hp: float:
	set(value):
		hp = value
		#print(hp, ' ', value, ' ', max_hp)
		_update_hp_bar()

@export var ATK: float = 1
@export var DEF: float = 1
@export var status_effect: StringName = 'null'
@export var alive: bool = true
@export var lvl: int = 1
@export var skills: ItemList = null
@export var ally: int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = base_stats
	#print(base_stats, ' ', stats)
	hp = max_hp
	$Pointer.set_position(Vector2(-100 * ally, 0))
	
	if ally > 0:
		$Pointer.set_texture(load("res://right_arrow.svg"))
	else:
		$Pointer.set_texture(load("res://left_arrow.svg"))
	#print(name, $Pointer.position)
	#print(hp)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	#var input_direction = Vector2()
	pass

func _update_hp_bar():
	$ProgressBar.value = (hp / max_hp) * 100

func focus():
	$Pointer.show()
	
func unfocus():
	$Pointer.hide()

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
	print(' %s healed %f HP' % [character_name, value])
	if hp > max_hp:
		hp = max_hp

func status():
	if status_effect == 'Toxin':
		damage(max_hp / 7)

func die():
	print('%s is dead' % [character_name])
	alive = false
