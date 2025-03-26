extends StatusBuff

func trigger(victim: Base_Character):
	victim.damage(magnitude * victim.max_hp)

	super.trigger(victim)
