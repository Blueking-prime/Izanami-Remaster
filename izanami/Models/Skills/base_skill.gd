class_name Skill

extends Resource

@export var name: StringName

@export var stats: Array[StringName] = []
@export var stat_multiplier: int = 1
@export var lvl_requirement: int = 1

@export var cost: int = 0

@export var flavour_text: String = ''
@export var desc: String
@export var type: StringName

@export var crit_chance: float = 0.2
@export var crit_mult: int = 2

@export var boost: Vector2 = Vector2(1, 1)
@export var status_effect: Script
@export var effect_duration: int = 3
@export var accuracy: float = 1

@export var aoe: bool = false
@export var targetable: bool = true

var value: int

func action(obj: Base_Character, target: Variant) -> bool:
	var stat_total = 0

	if obj.statuses.exhausted:
		return false

	if 'sp' in obj:
		if not obj.consume_sp(cost):
			return false

	if flavour_text != '':
		print(flavour_text)

	for stat in obj.stats:
		if stat in stats:
			stat_total += obj.stats[stat]

	obj.ATK *= boost.x
	obj.DEF *= boost.y

	print(stat_total)
	if Global.rand_chance(crit_chance):
		print('CRIT!')
		value = stat_total * stat_multiplier * crit_mult
	else:
		value = stat_total * stat_multiplier

	if status_effect:
		if aoe:
			for i in target:
				if Global.rand_chance(accuracy):
					var status: Status = status_effect.new()
					status.duration = effect_duration
					i.statuses.add_status(status)
				else:
					print('Miss!')
		else:
			if Global.rand_chance(accuracy):
				var status: Status = status_effect.new()
				status.duration = effect_duration
				target.statuses.add_status(status)
			else:
				print('Miss!')
	return true

#func rand_chance(chance: float) -> bool:
	#if randf() < chance:
		#return true
	#else:
		#return false
