extends Status

func _init() -> void:
	name = 'Death'
	super()

func trigger(victim: Base_Character):
	victim.hp = 0
	victim.alive = false
	if bool(extra_prop):
		victim.perma_dead = true

	super.trigger(victim)
