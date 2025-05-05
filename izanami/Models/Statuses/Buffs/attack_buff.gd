extends StatusBuff

func _init() -> void:
	desc = 'Attack'
	super._init()

func trigger(victim: Base_Character):
	victim.ATK += magnitude

	super.trigger(victim)
