extends Status

func _init() -> void:
	name = 'Restore'
	super()

func trigger(victim: Base_Character):
	victim.restore(victim.stats['END'])
	super.trigger(victim)
