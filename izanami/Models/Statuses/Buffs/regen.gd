extends StatusBuff

func _init() -> void:
	desc = 'Regen'

func trigger(victim: Base_Character):
	victim.heal(magnitude)

	super.trigger(victim)
