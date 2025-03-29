class_name Rune

extends StatusBuff

@export var element: StringName

func _init() -> void:
	desc = 'Rune'

func trigger(victim: Base_Character):
	victim.statuses.resistances[element] = magnitude
	victim.statuses.enchantment = element

	super.trigger(victim)
