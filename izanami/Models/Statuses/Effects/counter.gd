extends Status

func trigger(victim: Base_Character):
	victim.statuses.counterstance = true

	super.trigger(victim)
