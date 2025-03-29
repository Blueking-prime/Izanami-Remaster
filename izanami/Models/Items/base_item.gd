class_name Item

extends Resource

@export var name: StringName
@export var offensive: bool
@export var type: StringName
@export var value: int = 0
@export var status_effect: Script
@export var effect_duration: int
@export var effect_chance: float = 1
@export var desc: String
@export var price: int = 0
@export var aoe: bool = false
@export var universal: bool = false
@export var element: StringName

func use(target):
	if aoe or universal:
		for i in target:
			use_on_target(i)
	else:
		use_on_target(target)

func use_on_target(target: Base_Character):
	match type:
		'buff': use_buff(target)
		'heal': use_heal(target)
		'damage': use_damage(target)
		'cleanse': use_cleanse(target)


func use_buff(target: Base_Character):
	if Global.rand_chance(effect_chance):
		var status: Status = status_effect.new()
		status.duration = effect_duration
		target.statuses.add_status(status)
	else:
		print('Miss on ', target.character_name)

func use_heal(target: Base_Character):
	target.heal(value)

func use_damage(target: Base_Character):
	target.damage(value)

func use_cleanse(target: Base_Character):
	for i in target.statuses.status_effects:
		if i.get_script() == status_effect:
			target.statuses.status_effects.erase(i)
