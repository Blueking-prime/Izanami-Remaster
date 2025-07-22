extends VBoxContainer

@export var skill_menu_card_scene: PackedScene

## EXTERNAL PARAMETERS
@export var desc_box_container: BoxContainer
@export var target_selector: Options


func _ready() -> void:
	Global.description_box_parent = desc_box_container

func load_stock():
	_clear_data_cards()
	if Global.players:
		for i in Global.players.party:
			create_card(i)

func create_card(player: Player):
	var card: InventorySkillCard = skill_menu_card_scene.instantiate()
	card.desc_box_container = desc_box_container
	card.target_selector = target_selector
	card.player = player
	card.load_stock()

	add_child(card)

func _clear_data_cards():
	var children = get_children()
	if children:
		for i in children:
			remove_child(i)
			i.queue_free()


func _on_visibility_changed() -> void:
	if get_child(0) and visible:
		get_child(0).options.grab_focus()


func _input(event: InputEvent) -> void:
	if not visible: return

	var current_focus = get_viewport().gui_get_focus_owner()
	if not is_instance_valid(current_focus): return
	if current_focus is not Option: return

	if not is_ancestor_of(current_focus): return

	var curr_index = current_focus.root_menu.get_parent().get_parent().get_parent().get_index()


	if event.is_action_pressed("ui_focus_next"):
		if curr_index + 1 < get_child_count():
			get_child(curr_index + 1).options.call_deferred('grab_focus')
		else :
			get_child(0).options.call_deferred('grab_focus')
	if event.is_action_pressed("ui_focus_prev"):
		if curr_index - 1 >= 0:
			get_child(curr_index - 1).options.call_deferred('grab_focus')
		else :
			get_child(-1).options.call_deferred('grab_focus')
