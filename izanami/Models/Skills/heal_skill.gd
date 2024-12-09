class_name Heal_Skill

extends Skill

func action(obj: Base_Character, target: Base_Character):
	super.action(obj, target)
	target.heal(value)
