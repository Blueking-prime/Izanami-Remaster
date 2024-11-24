class_name Skill

extends Resource

@export var name: StringName
@export var stats: Array[StringName] = []
@export var stat_multiplier: int = 1
@export var cost: int = 0
@export var boost: Array = [1, 1]
@export var flavour_text: String = ''
@export var lvl_requirement: int = 1
@export var crit_chance: float = 0.2
@export var crit_mult: int = 2
@export var status_effect: Array
@export var value: int

func action(obj: Base_Character, target: Base_Character):
	var stat_total = 0
	var value = 0
	
	if obj.status_effect == 'Exhausted':
		return false

	if obj.has_meta('sp'):
		if obj.sp <= 0:
			print('Out of SP')
			return false
		obj.sp -= cost
		print('sp ', obj.sp)

	if flavour_text != '':
		print(flavour_text)

	for stat in obj.stats:
		if stat in stats:
			stat_total += obj.stats[stat]
	
	print(stat_total)
	if rand_chance(crit_chance):
		print('CRIT!')
		value = stat_total * stat_multiplier * crit_mult
	else:
		value = stat_total * stat_multiplier

	obj.ATK *= boost[0]
	obj.DEF *= boost[1]

	if status_effect:
		if rand_chance(status_effect[1]):
			target.status_effect = status_effect[0]
		else:
			print('Miss!')

	return true

func rand_chance(chance: float) -> bool:
	if randf() < chance:
		return true
	else:
		return false
