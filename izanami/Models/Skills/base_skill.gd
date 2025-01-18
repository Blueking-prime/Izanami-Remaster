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
@export var status_effect: StringName
@export var accuracy: float = 1
@export var value: int = 0
@export var aoe: bool = false
@export var targetable: bool = true
@export var desc: String
@export var type: StringName

func action(obj: Base_Character, target: Base_Character):
	var stat_total = 0

	if obj.status_effect == 'Exhausted':
		return false

	if 'sp' in obj:
		if not obj.consume_sp(cost):
			return false

	if flavour_text != '':
		print(flavour_text)

	for stat in obj.stats:
		if stat in stats:
			stat_total += obj.stats[stat]

	print(stat_total)
	if Global.rand_chance(crit_chance):
		print('CRIT!')
		value = stat_total * stat_multiplier * crit_mult
	else:
		value = stat_total * stat_multiplier

	obj.ATK *= boost[0]
	obj.DEF *= boost[1]

	if status_effect:
		if Global.rand_chance(accuracy):
			target.status_effect = status_effect
		else:
			print('Miss!')
	return true

#func rand_chance(chance: float) -> bool:
	#if randf() < chance:
		#return true
	#else:
		#return false
