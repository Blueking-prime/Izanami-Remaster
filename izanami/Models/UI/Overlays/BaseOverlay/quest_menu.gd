extends OverlayMenu

class_name QuestMenu

@export var active_menu: OptionMenu
@export var completed_menu: OptionMenu

func load_menu():
	active_menu.load_stock()
	completed_menu.load_stock()

	super.load_menu()

func _on_visibility_changed() -> void:
	super._on_visibility_changed()
	if visible:
		tab_container.get_child(Checks.quests_tab).show()
