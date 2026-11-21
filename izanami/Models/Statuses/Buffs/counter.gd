extends StatusBuff

func _init() -> void:
	name = 'Counter'
	super()

func trigger(victim: Base_Character):
	victim.statuses.counterstance = true
	if magnitude:
		victim.statuses.fixed_counter_damage = magnitude
	if extra_prop:
		victim.statuses.counter_element = str(extra_prop)

	super.trigger(victim)
