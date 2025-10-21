class_name Item

extends Resource

@export_category('Info')
## Name of item
@export var name: StringName
## Type of item used (buff, heal, cleanse, damage)
@export_enum('Effect', 'Heal', 'Damage', 'Cleanse') var type: String
## Item description
@export var desc: String
## Element item is effective against
@export_enum('Physical', 'Fire', 'Water', 'Wind', 'Dark', 'Light', 'Blood',) var element: String
@export_category('Stats')
## Amount of ‘x’ item does (if applicable)
@export var value: int = 0
## Check if item recovers SP
@export var sp_recover: bool
## Check if item recovers HP
@export var hp_recover: bool
## The status effect applied by this item
@export var status_effect: Script
## How many turns the status effect would last (if applicable)
@export var effect_duration: int
## Status effect magnitude (if applicable)
@export var effect_magnitude: float
## Chance for status effect to land (if applicable)
@export_range(0, 1, 0.05) var effect_chance: float = 1
## Cost of item
@export var price: int = 0
## Check if this is an offensive item (for targetting reasons)
@export var offensive: bool
## Check if item targets the whole team
@export var aoe: bool = false
## Check if item targets the whole field
@export var universal: bool = false
## Check if item is expired after one use
@export var reuseable: bool = false

func use(target):
	if aoe or universal:
		for i in target:
			use_on_target(i)
	else:
		use_on_target(target)

func use_on_target(target: Base_Character):
	match type:
		'Buff': use_buff(target)
		'Heal': use_heal(target)
		'Damage': use_damage(target)
		'Cleanse': use_cleanse(target)


func use_buff(target: Base_Character):
	if Global.rand_chance(effect_chance):
		var status: Status = status_effect.new()
		status.duration = effect_duration
		if status is StatusBuff: status.magnitude = effect_magnitude
		target.statuses.add_status(status)
	else:
		Global.print_to_log('Miss on ' + target.character_name)

func use_heal(target: Base_Character):
	if hp_recover:
		target.heal(value)
	if sp_recover and 'sp' in target:
		target.restore(value / 2)

func use_damage(target: Base_Character):
	if target.statuses.counterstance:
		target.statuses.counterstance = false
		return

	var el
	if element != '':
		el = element

	if el:
		value *= (1 - target.resistances[el])
		value *= (1 - target.statuses.resistances[el])
		if 'gear' in target:
			value *= (1 - target.gear.resistances[el])

	target.damage(value)

func use_cleanse(target: Base_Character):
	for i in target.statuses.status_effects:
		if i.get_script() == status_effect:
			target.statuses.status_effects.erase(i)
