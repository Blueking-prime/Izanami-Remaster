extends Status

func trigger(victim: Base_Character):
	victim.statuses.stunned = true

	super.trigger(victim)
