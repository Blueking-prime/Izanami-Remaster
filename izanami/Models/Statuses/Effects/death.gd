extends Status

func _init() -> void:
	desc = 'Death'

func trigger(victim: Base_Character):
	victim.hp = 0
	victim.alive = false
	if bool(extra_prop):
		victim.perma_dead = true

	super.trigger(victim)
