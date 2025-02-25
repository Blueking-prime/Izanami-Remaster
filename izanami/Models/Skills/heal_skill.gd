class_name Heal_Skill

extends Skill

func  _init() -> void:
	type = 'Heal Skill'

func action(obj: Base_Character, target: Variant) -> bool:
	if not super.action(obj, target): return false
	if aoe:
		for i in target:
			i.heal(value)
	else:
		target.heal(value)

	return true
