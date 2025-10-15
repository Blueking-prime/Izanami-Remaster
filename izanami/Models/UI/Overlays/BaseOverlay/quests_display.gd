extends VBoxContainer

class_name QuestsDisplay

@export var title: Label
@export var objective_cointainer: VBoxContainer

var displayed_objectives: Dictionary
var currently_displayed_quest: GlobalQuests.Quest

func connect_signals():
	if not Global.quests_changed.is_connected(_on_quests_updated):
		Global.quests_changed.connect(_on_quests_updated)

func update_quest():
	if not Global.current_quest or Global.current_quest.completed:
		default_display()
		return

	if not currently_displayed_quest or (Global.current_quest.title != currently_displayed_quest.title):
		currently_displayed_quest = Global.current_quest
		title.text = currently_displayed_quest.title
		_clear_objectives()

	_get_displayed_objectives()
	currently_displayed_quest.refresh_flags()

	update_objectives(Global.current_quest.objectives)

func update_objectives(objectives: Array):
	if not objectives.is_empty():
		$Objectives.show()

	for i in objectives:
		if i.title in displayed_objectives.keys():
			if i.value:
				displayed_objectives[i.title].queue_free()
				displayed_objectives.erase(i.title)
		else:
			if not i.value:
				display_objective(i)

func display_objective(objective: GlobalQuests.Quest.Objective):
	var objective_label: Label = Label.new()
	objective_label.text = '- ' + objective.title

	objective_cointainer.add_child(objective_label)

func _get_displayed_objectives():
	displayed_objectives.clear()
	for i in objective_cointainer.get_children():
		if is_instance_valid(i) and i is Label:
			displayed_objectives.get_or_add(i.text.trim_prefix('- '), i)

func _clear_objectives():
	$Objectives.hide()
	for i in objective_cointainer.get_children():
		objective_cointainer.remove_child(i)
		if is_instance_valid(i): i.queue_free()

func default_display():
	title.text = 'No active Quest'
	_clear_objectives()

func _on_quests_updated() -> void:
	update_quest()
