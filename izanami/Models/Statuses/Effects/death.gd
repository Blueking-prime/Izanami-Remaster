extends Status

func trigger(victim: Base_Character):
	victim.alive = false

	super.trigger(victim)
