extends StatusBuff

func trigger(victim: Base_Character):
	victim.DEF += magnitude

	super.trigger(victim)
