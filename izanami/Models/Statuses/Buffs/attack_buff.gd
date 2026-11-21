extends StatusBuff

func _init() -> void:
	name = 'Attack'
	super()

func trigger(victim: Base_Character):
	victim.ATK *= magnitude

	super.trigger(victim)
