extends Status

func _init() -> void:
	desc = 'ExExhaust'

func trigger(victim: Base_Character):
	victim.statuses.exhausted = true
	victim.DEF *= 0.5

	super.trigger(victim)
