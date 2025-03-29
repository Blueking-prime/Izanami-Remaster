extends Status

func _init() -> void:
	desc = 'Restore'

func trigger(victim: Base_Character):
	victim.sp += victim.stats['END']
	print(victim.character_name, ' restored sp ', victim.stats['END'])
	if victim.sp > victim.max_sp:
		victim.sp = victim.max_sp

		super.trigger(victim)
