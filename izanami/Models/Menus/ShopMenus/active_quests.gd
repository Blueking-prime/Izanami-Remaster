extends OptionMenu

## EXTERNAL PARAMETERS
#@export var desc_box_container: BoxContainer
@export var objective_list: Options

## WORKING VARIABLES
var quests: Array:
	get():
		return Global.active_quest_list
	set(arg):
		Global.active_quest_list = arg

var current_quest: GlobalQuests.Quest:
	get():
		return Checks.current_quest

const CURRENT_LABEL_INDEX: int = 1

#func _ready() -> void:
	#Global.description_box_parent = desc_box_container
#
func load_stock():
	update_listing()

func update_listing():
	options.clear()
	Global.update_quests()

	if not quests.is_empty():
		for i in quests:
			options.add_item(
				i.title
			)

	if current_quest in quests:
		var current_quest_index = quests.find(current_quest)
		options.get_item_option(current_quest_index).add_label('Current')


func show_objectives(quest: GlobalQuests.Quest):
	objective_list.clear()
	for i in quest.objectives:
		objective_list.add_item(
			i.title,
			['✓' if i.value else '✗']
		)
	objective_list.disable()
	objective_list.show()
	#objective_list.grab_focus()


func _on_item_activated(index: int) -> void:
	if current_quest in quests:
		var current_index = quests.find(current_quest)
		if options.get_item_option(current_index).container.get_child_count() > 1:
			var current_label: Label = options.get_item_option(current_index).container.get_child(CURRENT_LABEL_INDEX)
			if current_label.text == 'Current':
				current_label.get_parent().remove_child(current_label)
				if is_instance_valid(current_label): current_label.queue_free()

	Global.set_active_quest(quests[index])
	options.get_item_option(index).add_label('Current')
	_on_item_selected(index)

func _on_item_selected(index: int) -> void:
	var quest: GlobalQuests.Quest = quests[index]
	show_objectives(quest)

func _on_visibility_changed() -> void:
	if visible:
		options.grab_focus()
		Checks.quests_tab = get_index()
	else :
		objective_list.hide()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and objective_list.visible:
		objective_list.hide()
