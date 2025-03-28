extends Status

func trigger(victim: Base_Character):
	victim.DEF = (2 ** 32)

	super.trigger(victim)
