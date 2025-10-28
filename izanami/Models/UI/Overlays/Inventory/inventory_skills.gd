extends Control

class_name InventorySkillMenu

@export var skill_menu_card_scene: PackedScene
@export var container: VBoxContainer

## EXTERNAL PARAMETERS
@export var target_selector: Options
var curr_index: int

func load_stock():
	_clear_data_cards()
	if Global.players:
		for i in Global.players.party:
			create_card(i)

func create_card(player: Player) -> InventorySkillCard:
	var card: InventorySkillCard = skill_menu_card_scene.instantiate()
	card.target_selector = target_selector
	card.player = player
	card.load_stock()

	container.add_child(card)
	return card

func _clear_data_cards():
	var children = container.get_children()
	if children:
		for i in children:
			container.remove_child(i)
			i.queue_free()


func _on_visibility_changed() -> void:
	if container.get_child(0) and visible:
		Audio.play_switch_menu_sfx()
		if container.get_child(0).options.is_inside_tree(): container.get_child(0).options.grab_focus()
		if get_parent() is TabContainer: Checks.inventory_tab = get_index()


func _input(event: InputEvent) -> void:
	if not visible: return

	var current_focus = get_viewport().gui_get_focus_owner()
	if not is_instance_valid(current_focus): return
	if current_focus is not Option: return

	if not is_ancestor_of(current_focus): return

	curr_index = current_focus.root_menu.get_parent().get_parent().get_parent().get_index()


	if event.is_action_pressed("ui_focus_next"):
		if curr_index + 1 < container.get_child_count():
			container.get_child(curr_index + 1).options.call_deferred('grab_focus')
		else :
			container.get_child(0).options.call_deferred('grab_focus')
	if event.is_action_pressed("ui_focus_prev"):
		if curr_index - 1 >= 0:
			container.get_child(curr_index - 1).options.call_deferred('grab_focus')
		else :
			container.get_child(-1).options.call_deferred('grab_focus')
