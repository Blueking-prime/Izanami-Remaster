extends Skill

class_name UniqueSpellBindingCircle

@export var ATK_buff: Script
@export var DEF_buff: Script

func action(obj: Base_Character, target_: Variant) -> bool:
	if not super.action(obj, target_):
		return false

	for i in obj.statuses.status_effects:
		if i is Azure_Rune:
			azure_heal(target_)
		if i is Flare_Rune:
			_apply_status(obj, obj, ATK_buff)
		if i is Zephyr_Rune:
			_apply_status(obj, obj, DEF_buff)

	return true

func azure_heal(_target):
	for i in _target:
		if i.alive:
			i.heal(value)
