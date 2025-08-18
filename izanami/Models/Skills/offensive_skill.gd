class_name Offensive_Skill

extends Skill

## Element skill is effective against
@export var element: StringName = ''

## Ststus effect skill is effective against
@export var status_modifier: Script
## Multiplier for effectiveness against status effect
@export var status_effectiveness: float = 1.5

## Check if skill canhit multiple times
@export var multi_hit: bool = false
## Max number of additinal hits
@export var multi_hit_max: int = 1
## Chance for additional hits
@export var multi_hit_chance: float = 0.5

func  _init() -> void:
	type = 'Offensive Skill'

func action(obj: Base_Character, target: Variant) -> bool:
	if not super.action(obj, target): return false
	obj.audio.play_attack_sfx()
	if aoe or universal:
		if random_target:
			var target_indexes = []
			for i in target_no:
				target_indexes.append(randi_range(0, target.size() - 1))

			for i in target_indexes:
				act(obj, target[i])

		else:
			for i in target:
				act(obj, i)
				if multi_hit:
					for j in Global.rand_spread(multi_hit_chance, multi_hit_max):
						act(obj, i)
	else:
		act(obj, target)
		if multi_hit:
			for j in Global.rand_spread(multi_hit_chance, multi_hit_max):
				act(obj, target)
	return true

func act(obj: Base_Character, target: Base_Character):
	#target = target as Base_Character

	if target.statuses.counterstance:
		target.statuses.counterstance = false
		target = obj

	#print('act begin value = ', value)

	var el
	if element != '':
		el = element
	elif obj.statuses.enchantment != '':
		el = obj.statuses.enchantment

	if el:
		value *= (1 - target.resistances[el])
		value *= (1 - target.statuses.resistances[el])

	#print('act resist value = ', value)

	if status_modifier:
		if status_modifier in target.statuses.status_effects_scripts:
			value *= status_effectiveness

	#print('act staus value = ', value)

	value *= obj.ATK

	#print('act final value = ', value)

	target.damage(value)
