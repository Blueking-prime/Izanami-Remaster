extends StatusBuff

func _init() -> void:
	name = 'Bleed'
	super()

func trigger(victim: Base_Character):
	victim.damage(magnitude * victim.max_hp)

	super.trigger(victim)
