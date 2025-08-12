extends OptionMenu

## EXTERNAL PARAMETERS
#@export var desc_box_container: BoxContainer
@export var objective_list: Options

## WORKING VARIABLES
var quests: Array:
	get():
		return Checks.completed_quests

#func _ready() -> void:
	#Global.description_box_parent = desc_box_container
#
func load_stock():
	update_listing()

func update_listing():
	options.clear()

	if not quests.is_empty():
		for i in quests:
			options.add_item(
				i.title
			)

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
