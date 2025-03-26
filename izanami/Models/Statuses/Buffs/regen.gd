extends StatusBuff

func trigger(victim: Base_Character):
	victim.heal(magnitude)

	super.trigger(victim)
