extends Status

func trigger(victim: Base_Character):
	victim.stunned = true

	super.trigger(victim)
