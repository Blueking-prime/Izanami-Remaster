class_name Heal_Skill

extends Skill

## Check if skill recovers sp
@export var sp_recover: bool
## Check if skill recovers hp
@export var hp_recover: bool
## Restore HP and SP based of max values
@export var percent_heal: bool = false
## Amount of max SP skill recovers compared to HP (if applicable)
@export var max_sp_fraction: Array[float] = [1, 1, 1]
## Amount of max HP skill recovers compared to HP (if applicable)
@export var max_hp_fraction: Array[float] = [1, 1, 1]
## Amount of relative SP skill recovers compared to HP (if applicable)
@export var sp_fraction: float = 0.5
## Check if skill revives its target
@export var revive_skill: bool = false

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

func revive(target: Base_Character):
	if revive_skill and not target.alive and not target.perma_dead:
		target.alive = true

func cleanse(target: Base_Character):
	for j in target.statuses.status_effects.duplicate():
		if j.get_script() in conditions:
			if j.name == 'ExExhaust' and 'sp' in target:
				target.sp = 0
			if j.name == 'Death' and j.extra_prop:
				continue
			target.statuses.remove_status(j)

func heal(target: Base_Character):
	revive(target)
	cleanse(target)
	if target.alive:
		if hp_recover:
			if percent_heal:
				target.heal(target.max_hp * max_hp_fraction[rank])
			else:
				target.heal(value)
		if sp_recover and 'sp' in target:
			if percent_heal:
				target.restore(target.max_sp * max_sp_fraction[rank])
			else:
				target.restore(value * sp_fraction)
