class_name Heal_Skill

extends Skill

func  _init() -> void:
	type = 'Heal Skill'

func action(obj: Base_Character, target: Base_Character):
	super.action(obj, target)
	target.heal(value)
