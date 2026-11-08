extends Status

func _init() -> void:
	desc = 'Enchant with element'

func trigger(victim: Base_Character):
	victim.statuses.enchantment = StringName(extra_prop)

	super.trigger(victim)
