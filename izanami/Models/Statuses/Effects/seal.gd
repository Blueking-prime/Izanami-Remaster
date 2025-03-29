extends Status

func _init() -> void:
	desc = 'Seal'

func trigger(victim: Base_Character):
	victim.statuses.exhausted = true

	super.trigger(victim)
