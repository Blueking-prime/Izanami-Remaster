extends VBoxContainer

class_name QuestsDisplay

@export var title: Label
@export var objective_cointainer: VBoxContainer

var displayed_objectives: Dictionary
var current_quest: Quest

# Temp Quest Structure
class Quest:
	var title: StringName
	var objectives: Array[Objective]
	var completed: bool = false

	class Objective:
		var title: String
		var flag: StringName
		var value: Variant

		func _init(_title: String, _flag: StringName, _value: Variant) -> void:
			self.title = _title
			if Checks.get(_flag):
				self.flag = _flag
				self.value = Checks.get(_flag)
			else :
				assert(false, '%s not contained in Checks' % [_flag])

	func _init(_title: String, _objectives: Array) -> void:
		self.title = _title
		self.objectives = _objectives

	func refresh_flags():
		for i in self.objectives:
			i.value = Checks.get(i.flag)

func update_quest(quest: Quest):
	if not quest.title == current_quest.title:
		current_quest = quest
		_clear_objectives()

	_get_displayed_objectives()
	current_quest.refresh_flags()

	update_objectives(quest.objectives)

func update_objectives(objectives: Array[Quest.Objective]):
	for i in objectives:
		if i.title in displayed_objectives.keys():
			if i.value:
				displayed_objectives[i.title].queue_free()
				displayed_objectives.erase(i.title)
		else:
			if not i.value:
				display_objective(i)


func display_objective(objective: Quest.Objective):
	var objective_label: Label = Label.new()
	objective_label.text = '- ' + objective.title

	objective_cointainer.add_child(objective_label)

func _get_displayed_objectives():
	displayed_objectives.clear()
	for i in objective_cointainer.get_children():
		if is_instance_valid(i) and i is Label:
			displayed_objectives.get_or_add(i.text.trim_prefix('- '), i)

func _clear_objectives():
	for i in objective_cointainer.get_children():
		if is_instance_valid(i):
			objective_cointainer.remove_child(i)
			i.queue_free()
