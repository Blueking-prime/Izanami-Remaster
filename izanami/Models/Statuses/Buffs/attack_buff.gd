extends StatusBuff

func _init() -> void:
	desc = 'Attack'

func trigger(victim: Base_Character):
	victim.ATK += magnitude

	super.trigger(victim)
