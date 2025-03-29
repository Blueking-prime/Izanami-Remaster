extends Status

func _init() -> void:
	desc = 'Stun'

func trigger(victim: Base_Character):
	victim.statuses.stunned = true

	super.trigger(victim)
