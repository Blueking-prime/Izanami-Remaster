class_name Heal_Skill

extends Skill

## Check if skill recovers sp
@export var sp_recover: bool
## Check if skill recovers hp
@export var hp_recover: bool
## Amount of relative SP skill recovers compared to HP (if applicable)
@export var sp_fraction: float = 0.5

func  _init() -> void:
	type = 'Support'

func action(obj: Base_Character, target: Variant) -> bool:
	if not super.action(obj, target): return false
	obj.audio.play_heal_sfx()
	if aoe or universal:
		if random_target:
			var target_indexes = []
			for i in target_no:
				target_indexes.append(randi_range(0, target.size() - 1))

			for i in target_indexes:
				heal(target[i])

		for i in target:
			heal(i)
	else:
		heal(target)

	return true

func heal(target: Base_Character):
	if hp_recover:
		target.heal(value)
	if sp_recover and 'sp' in target:
		target.restore(value * sp_fraction)
