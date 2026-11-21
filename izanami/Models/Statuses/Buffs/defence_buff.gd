extends StatusBuff

func _init() -> void:
	name = 'Defence'
	super()

func trigger(victim: Base_Character):
	victim.DEF *= magnitude

	super.trigger(victim)
