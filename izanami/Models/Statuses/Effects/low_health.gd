extends Status

func _init() -> void:
	desc = 'Low'

func trigger(victim: Base_Character):
	victim.statuses.hp_low = true

	super.trigger(victim)
