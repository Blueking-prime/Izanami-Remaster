extends Status

func _init() -> void:
	name = 'Toxin'
	super()

func trigger(victim: Base_Character):
	victim.damage(victim.max_hp / 7)

	super.trigger(victim)
