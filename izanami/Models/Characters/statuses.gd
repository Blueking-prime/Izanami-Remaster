extends Node

class_name CharacterStatuses

@export var status_effects: Array[Status]
@export var test_effect: Script

@export var en_exhaust: Script
@export var restore: Script

func test():
	print(test_effect)
	for i in 3:
		add_status(test_effect.new())
	print(status_effects)
	for i in 10:
		print(get_parent().hp)
		await get_tree().create_timer(3).timeout
		trigger_status()
		expire_status()
	pass

func status():
	reset_status()
	auto_ailment()
	trigger_status()
	expire_status()


func reset_status():
	get_parent().stunned = false
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
			status_effects.erase(i)

func add_status(status: Status):
	status_effects.append(status)
