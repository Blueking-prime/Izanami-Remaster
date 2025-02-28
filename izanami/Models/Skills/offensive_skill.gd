class_name Offensive_Skill

extends Skill

@export var element: StringName = ''
@export var status_modifier: Script
@export var effectiveness: float = 1.5

@export var multi_hit: bool = false
@export var multi_hit_max: int = 1
@export var multi_hit_chance: float = 0.5

func  _init() -> void:
	type = 'Offensive Skill'

func action(obj: Base_Character, target: Variant) -> bool:
	if not super.action(obj, target): return false
	if aoe:
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
	target = target as Base_Character
	if target.has_meta('element'):
		if element == target.element:
			value *= effectiveness
	if status_modifier:
		if status_modifier in target.statuses.status_effects_scripts:
			value *= effectiveness

	value *= obj.ATK
	target.damage(value)
