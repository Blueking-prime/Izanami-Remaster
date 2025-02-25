extends Status

@export var DEF: float

func trigger(victim: Base_Character):
	victim.DEF += DEF

	super.trigger(victim)
