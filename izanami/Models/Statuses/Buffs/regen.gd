extends StatusBuff

func _init() -> void:
	name = 'Regen'
	super()

func trigger(victim: Base_Character):
	victim.heal(magnitude)

	super.trigger(victim)
