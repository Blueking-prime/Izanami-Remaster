extends StatusBuff

func trigger(victim: Base_Character):
	victim.ATK += magnitude

	super.trigger(victim)
