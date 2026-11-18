extends Status

func _init() -> void:
	desc = 'Restore'

func trigger(victim: Base_Character):
	victim.restore(victim.stats['END'])
	super.trigger(victim)
