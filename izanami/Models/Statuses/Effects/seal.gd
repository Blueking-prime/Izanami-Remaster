extends Status

func trigger(victim: Base_Character):
	victim.statuses.exhausted = true

	super.trigger(victim)
