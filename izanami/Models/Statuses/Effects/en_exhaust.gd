extends Status

func trigger(victim: Base_Character):
	victim.sp -= victim.max_sp / 4

	super.trigger(victim)
