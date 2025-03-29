extends StatusBuff

func _init() -> void:
	desc = 'Defence'

func trigger(victim: Base_Character):
	victim.DEF += magnitude

	super.trigger(victim)
