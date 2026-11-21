extends Status

func _init() -> void:
	name = 'Hidden'
	super()

func trigger(victim: Base_Character):
	victim.statuses.targetable = false

	super.trigger(victim)
