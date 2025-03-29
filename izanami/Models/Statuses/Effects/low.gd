extends Status

func _init() -> void:
	desc = 'Low'

func trigger(victim: Base_Character):
	victim.statuses.low_health = true

	super.trigger(victim)
