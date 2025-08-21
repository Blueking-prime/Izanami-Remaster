class_name Skill

extends Resource

@export var name: StringName

## Stats the skill scales off
const stat_names: Array[StringName] = ["STR", "INT", "WIS", "END", "GUI", "AGI"]
var _stats: Array[StringName] = []
@export_flags("STR", "INT", "WIS", "END", "GUI", "AGI") var stats: int:
	set(arg):
		if _stats.is_empty():
			for i in range(stat_names.size()):
				var flag_value = 1 << i # Calculate power of 2 for current flag
				if arg & flag_value: _stats.append(stat_names[i])
	get():
		var count: int = 0
		for i in _stats:
			count += stat_names.find(i) ^ 2
		return count

## Value stats are multiplied by to calculate effect value
@export var stat_multiplier: Array[float] = [1, 1, 1]
## Requirement to unlock skill
@export var lvl_requirement: int = 1
## Requirements to activate skill
@export var conditions: Array[Script]
## Chance for skill to land
@export_range(0, 1, 0.05) var accuracy: Array[float] = [1, 1, 1]

## Current Skill rank
@export var rank: int = 0

## Stamina Cost to use skill
@export var cost: int = 0
## Health Cost to use skill (in percentage of max HP)
@export_range(0, 1, 0.01) var hp_cost: float

## Text diaplayed when skill is used
@export var flavour_text: String = ''
## Skill effect descriptor
@export var desc: String
## Type of skill used
var type: StringName

## Chance for a skill to be a crit
@export_range(0, 1, 0.05) var crit_chance: Array[float] = [0.2, 0.2, 0.2]
## If skill is a crit, the base value is multiplied by this
@export var crit_mult: Array[float] = [2, 2, 2]

## Effect on users ATK and DEF attributes respectively (multiplicative)
@export var boost: Array[Vector2] = [Vector2(1, 1), Vector2(1, 1), Vector2(1, 1)]
## The status effect applied by this skill
@export var status_effect: Script
## How many turns the status effect would last (if applicable)
@export var effect_duration: Array[int] = [3, 3, 3]
## Magnitude of status effects effect if status effect is a buff/debuff (if applicable)
@export var effect_magnitude: Array[float]
## Stats the effect_magnitude scales off (if applicable)
@export var effect_mag_stats: Array[StringName] = []
## Chance for status effect to land (if applicable)
@export_range(0, 1, 0.05) var effect_chance: Array[float] = [1, 1, 1]

## Check if skill targets whole team
@export var aoe: bool = false
## Check if skill targets the whole field
@export var universal: bool = false
## Check if target is random
@export var random_target: bool = false
## Numberof random targets
@export var target_no: int = 1
## Check if skill can target others besides self
@export var targetable: bool = true

## WORKING VARIABLES
var value: int

func action(obj: Base_Character, target: Variant) -> bool:
	var stat_total = 0

	if not Global.rand_chance(accuracy[rank]): return false

	if conditions:
		var condidtion_check = false
		for i in conditions:
			if i in target.statuses.status_effects_scripts:
				condidtion_check = true
				break

		if not condidtion_check: return false

	if obj.statuses.exhausted: return false

	if 'sp' in obj:
		if not obj.consume_sp(cost):
			return false

	if hp_cost:
		obj.damage(obj.max_hp * hp_cost)

	if flavour_text != '':
		Global.print_to_log(flavour_text)

	for stat in obj.stats:
		if stat in _stats:
			stat_total += obj.stats[stat]

	obj.ATK *= boost[rank].x
	obj.DEF *= boost[rank].y

	value = stat_total * stat_multiplier[rank]

	if Global.rand_chance(crit_chance[rank]):
		Global.print_to_log('CRIT!')
		value *= crit_mult[rank]

	if status_effect:
		obj.audio.play_support_sfx()
		if aoe:
			for i in target:
				_apply_status(obj, i)
		else:
			_apply_status(obj, target)

	#Global.print_to_log('base value = ', value)
	return true

func _apply_status(obj: Base_Character, target: Base_Character):
	if Global.rand_chance(effect_chance[rank]):
		var status: Status = status_effect.new()
		status.duration = effect_duration[rank]

		if status is StatusBuff:
			var mag_stat_total = 0
			status.magnitude = effect_magnitude

			for stat in obj.stats:
				if stat in effect_mag_stats:
					mag_stat_total += obj.stats[stat]
			if mag_stat_total > 0:
				status.magnitude *= mag_stat_total

		target.statuses.add_status(status)
		target.audio.play_status_sfx()
	else:
		Global.print_to_log('Miss on ' + target.character_name + '!')


#func rand_chance(chance: float) -> bool:
	#if randf() < chance:
		#return true
	#else:
		#return false
