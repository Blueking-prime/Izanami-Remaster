extends Status

func _init() -> void:
	desc = 'Immortal'

func trigger(victim: Base_Character):
	victim.DEF = INF

	super.trigger(victim)
