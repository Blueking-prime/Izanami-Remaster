extends Status

func _init() -> void:
	desc = 'Hidden'

func trigger(victim: Base_Character):
	victim.statuses.targetable = false

	super.trigger(victim)
