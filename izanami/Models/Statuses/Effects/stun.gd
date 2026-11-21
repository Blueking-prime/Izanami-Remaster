extends Status

func _init() -> void:
	name = 'Stun'
	super()

func trigger(victim: Base_Character):
	victim.statuses.stunned = true

	super.trigger(victim)
