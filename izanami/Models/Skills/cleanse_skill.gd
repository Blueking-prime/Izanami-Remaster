class_name Cleanse_Skill

extends Skill

func  _init() -> void:
	type = 'Cleanse Skill'

func action(obj: Base_Character, target: Variant) -> bool:
	if not super.action(obj, target): return false
	obj.audio.play_heal_sfx()
	if aoe or universal:
		if random_target:
			var target_indexes = []
			for i in target_no:
				target_indexes.append(randi_range(0, target.size() - 1))

			for i in target_indexes:
				cleanse(target[i])

		for i in target:
			cleanse(i)
	else:
		cleanse(target)

	return true

func cleanse(target: Base_Character):
	for i in conditions:
		for j in target.statuses.status_effects:
			if j.get_script() == i:
				target.statuses.remove_status(j)
