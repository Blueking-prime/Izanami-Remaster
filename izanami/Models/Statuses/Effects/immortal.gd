extends Status

func _init() -> void:
	desc = 'Immortal'

func trigger(victim: Base_Character):
	victim.DEF = (2 ** 32)

	super.trigger(victim)
