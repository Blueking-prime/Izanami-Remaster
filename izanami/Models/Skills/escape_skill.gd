extends Skill

class_name EscapeSkill

func action(obj: Base_Character, target: Variant) -> bool:
	var battle = obj.get_tree().current_scene
	if not (battle is Battle):
		Global.show_info_popup("Escape skills can only be used during battle.")
		return false

	if not super.action(obj, target):
		return false

	Global.print_to_log("You escaped")
	battle.setup.exit_battle("run")

	return true
