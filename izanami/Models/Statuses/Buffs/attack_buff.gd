extends Status

@export var ATK: float

func trigger(victim: Base_Character):
	victim.ATK += ATK

	super.trigger(victim)
