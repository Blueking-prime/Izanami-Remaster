extends Status

func _init() -> void:
	desc = 'Toxin'

func trigger(victim: Base_Character):
	victim.damage(victim.max_hp / 7)

	super.trigger(victim)
