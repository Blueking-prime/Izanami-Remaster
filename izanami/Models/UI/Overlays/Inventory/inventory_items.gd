extends OptionMenu

## EXTERNAL PARAMETERS
@export var target_selector: Options

## WORKING VARIABLES
var inventory: Inventory
var selected_item_name: String


func load_stock():
	if Global.players:
		inventory = Global.players.inventory
	update_listing()

func update_listing():
	options.clear()

	if inventory:
		for i in inventory.item_data:
			options.add_item(
				i,
				[str(len(inventory.item_data[i]))]
			)

func show_target_selector():
	target_selector.clear()
	for i in Global.players.party:
		target_selector.add_icon_item(
			i.battle_sprite_texture.texture,
			i.character_name
		)
	target_selector.show()
	target_selector.grab_focus()

func choose_target(index: int):
	Global.players.leader.use_item(selected_item_name, Global.players.party[index])
	target_selector.hide()
	update_listing()

func _on_item_activated(index: int) -> void:
	selected_item_name = options.get_item_text(index)
	print(index)
	print(selected_item_name)
	if inventory.get_entry_by_name(selected_item_name).aoe:
		Global.players.leader.use_item(selected_item_name, Global.players.party)
		update_listing()
	else:
		show_target_selector()
	_on_item_selected(index)

func _on_item_selected(index: int) -> void:
	var item = inventory.get_entry_by_name(options.get_item_text(index))
	if item:
		Global.show_description(item)


func _on_visibility_changed() -> void:
	if visible:
		Audio.play_switch_menu_sfx()
		options.grab_focus()
		Checks.inventory_tab = get_index()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and target_selector.visible:
		target_selector.hide()
