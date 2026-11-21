extends Status

func _init() -> void:
	name = 'Seal'
	super()

func trigger(victim: Base_Character):
	victim.statuses.exhausted = true

	super.trigger(victim)
