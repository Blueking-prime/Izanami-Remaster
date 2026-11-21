extends Status

func _init() -> void:
	name = 'Immortal'
	super()

func trigger(victim: Base_Character):
	victim.DEF = INF

	super.trigger(victim)
