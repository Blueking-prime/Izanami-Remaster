class_name Item

extends Resource

@export_category('Info')
@export var name: StringName
@export_enum('Effect', 'Heal', 'Damage', 'Cleanse') var type: String
@export var desc: String
@export_enum('Physical', 'Fire', 'Water', 'Wind', 'Dark', 'Light', 'Blood',) var element: String
@export_category('Stats')
@export var value: int = 0
@export var sp_recover: bool
@export var hp_recover: bool
@export var status_effect: Script
@export var effect_duration: int
@export var effect_magnitude: float
@export_range(0, 1, 0.05) var effect_chance: float = 1
@export var price: int = 0
@export var offensive: bool
@export var aoe: bool = false
@export var universal: bool = false

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
		print('Miss on ', target.character_name)

func use_heal(target: Base_Character):
	if hp_recover:
		target.heal(value)
	if sp_recover and 'sp' in target:
		target.restore(value / 2)

func use_damage(target: Base_Character):
	if target.statuses.counterstance:
		target.statuses.counterstance = false
		return

	#print('act begin value = ', value)

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
