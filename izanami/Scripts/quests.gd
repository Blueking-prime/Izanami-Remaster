extends Node

class_name GlobalQuests

class Quest:
	var title: StringName
	var objectives: Array
	var completed: bool = false

	class Objective:
		var title: String
		var flag: StringName
		var value: Variant

		func _init(_title: String, _flag: StringName) -> void:
			self.title = _title
			if Checks.get(_flag) != null:
				self.flag = _flag
				self.value = Checks.get(_flag)
			else :
				assert(false, '%s not contained in Checks' % [_flag])

	func _init(_title: String, _objectives: Array) -> void:
		self.title = _title
		self.objectives = _objectives
		#print('Assigned Title: ', self.title)
		#print('Assigned Objectives: ', self.objectives)

	func refresh_flags():
		var check: bool = true
		for i in self.objectives:
			i.value = Checks.get(i.flag)
			if not i.value: check = i.value

		if check:
			completed = check

func load_quests():
	pass

func add_quest(quest: Quest):
	if quest not in get_parent().active_quest_list:
		get_parent().active_quest_list.append(quest)
	if not Checks.current_quest:
		set_active_quest(quest)

func set_active_quest(quest: Quest, update: bool = true):
	Checks.current_quest = quest
	if update:
		update_quests()

func update_quests():
	for i in get_parent().active_quest_list:
		i.refresh_flags()
		if i.completed:
			if i == Checks.current_quest:
				_set_new_curent_quest()
			Checks.completed_quests.append(i)
			get_parent().active_quest_list.erase(i)

	get_parent().quests_changed.emit()
	#print('Refreshed')


func _set_new_curent_quest():
	if get_parent().active_quest_list.back():
		set_active_quest(get_parent().active_quest_list.back(), false)
	else :
		set_active_quest(null, false)
