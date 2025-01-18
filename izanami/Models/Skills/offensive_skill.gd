class_name Offensive_Skill

extends Skill

@export var element: StringName = ''

func  _init() -> void:
	type = 'Offensive Skill'

func action(obj: Base_Character, target: Base_Character):
	var val = super.action(obj, target)
	if target.has_meta('element'):
		if element == target.element:
			value *= 2
	value *= obj.ATK
	target.damage(value)
	return val
