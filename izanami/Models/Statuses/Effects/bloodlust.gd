extends Status

func _init() -> void:
	name = 'Bloodlust'
	super()

func trigger(victim: Base_Character):
	victim.ATK *= 2

	victim.statuses.add_status(victim.statuses.ex_exhaust.new())

	super.trigger(victim)
