class_name Item

extends Resource

@export var name: StringName
@export var type: StringName 
@export var value: int = 0
@export var boost: Array = [1, 1]
@export var status_effect: Array
@export var desc: String

func use(target):
	match type:
		'buff': use_buff(target)
		'heal': use_heal(target)
		'damage': use_damage(target)
		'cleanse': use_cleanse(target)

func use_buff(target):
	target.ATK *= boost[0]
	target.DEF *= boost[1]

func use_heal(target):
	target.heal(value)

func use_damage(target):
	target.damage(value)

func use_cleanse(target):
	if target.status_effect == status_effect[0]:
		target.status_effect = 'null'
	else:
		print('No effect')
