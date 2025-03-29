extends Status

func _init() -> void:
	desc = 'Counter'

func trigger(victim: Base_Character):
	victim.statuses.counterstance = true

	super.trigger(victim)
