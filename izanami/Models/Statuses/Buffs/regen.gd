extends StatusBuff

func _init() -> void:
	desc = 'Regen'
	super._init()

func trigger(victim: Base_Character):
	victim.heal(magnitude)

	super.trigger(victim)
