extends Status

func _init() -> void:
	desc = 'Bloodlust'

func trigger(victim: Base_Character):
	victim.ATK *= 2
	victim.DEF *= 0.5

	victim.statuses.add_status(victim.statuses.en_exhaust.new())

	super.trigger(victim)
