class_name Offensive_Skill

extends Skill

@export var element: StringName = ''

func  _init() -> void:
	type = 'Offensive Skill'

func action(obj: Base_Character, target: Variant) -> bool:
	if not super.action(obj, target): return false
	if aoe:
		for i in target:
			if i.has_meta('element'):
				if element == i.element:
					value *= 2
			value *= obj.ATK
			i.damage(value)
	else:
		if target.has_meta('element'):
			if element == target.element:
				value *= 2
		value *= obj.ATK
		target.damage(value)
	return true
