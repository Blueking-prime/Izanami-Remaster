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


func update_quests():
	Checks.current_quest.refresh_flags()
	if get_tree().current_scene is Location:
		get_tree().current_scene.overlay.quests.update_quest(Checks.current_quest)
	#print('Refreshed')
