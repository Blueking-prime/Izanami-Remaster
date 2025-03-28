extends Node

class_name CharacterStatuses

@export var status_effects: Array[Status]
@export var status_effects_scripts: Array[Script]

@export var test_effect: Script

@export var en_exhaust: Script
@export var restore: Script

## Gives character resistance to elemental trait
@export var resistances: Dictionary = {
	'Physical':	0,
	'Fire':		0,
	'Water':	0,
	'Wind':		0,
	'Dark':		0,
	'Light':	0,
	'Blood':	0,
}

## Gives all character skills elemental trait
@export var enchantment: StringName

var stunned: bool = false
var exhausted: bool = false
var counterstance: bool = false

func test():
	#print(test_effect)
	#for i in 3:
		#add_status(test_effect.new())
	#print(status_effects)
	#for i in 10:
		#print(get_parent().hp)
		#await get_tree().create_timer(3).timeout
		#trigger_status()
		#expire_status()
	pass

func status():
	reset_status()
	auto_ailment()
	trigger_status()
	expire_status()


func reset_status():
	stunned = false
	exhausted = false
	enchantment = ''
	for i in resistances: resistances[i] = 0

	get_parent().ATK = 1
	get_parent().DEF = 1

func auto_ailment():
	if get_parent() is Player:
		add_status(restore.new())
		if get_parent().sp < 0:
			add_status(en_exhaust.new())

func trigger_status():
	for i in status_effects:
		i.trigger(get_parent())

func expire_status():
	for i in status_effects:
		if i.elapsed >= i.duration:
			remove_status(i)

func add_status(_status: Status):
	if _status is not StatusBuff and _status.get_script() in status_effects_scripts:
		print('No effect!')
		return

	status_effects.append(_status)
	status_effects_scripts.append(_status.get_script())

func remove_status(_status: Status):
	status_effects.erase(_status)
	status_effects_scripts.erase(_status.get_script())
