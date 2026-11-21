extends Status

func _init() -> void:
	name = 'Enchant with element'
	super()

func trigger(victim: Base_Character):
	victim.statuses.enchantment = StringName(extra_prop)

	super.trigger(victim)
