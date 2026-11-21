extends Status

func _init() -> void:
	name = 'Low'
	super()

func trigger(victim: Base_Character):
	victim.statuses.hp_low = true

	super.trigger(victim)
