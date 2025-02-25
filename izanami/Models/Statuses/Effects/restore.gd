extends Status

func trigger(victim: Base_Character):
	victim.sp += victim.stats['END']
	if victim.sp > victim.max_sp:
		victim.sp = victim.max_sp

		super.trigger(victim)
