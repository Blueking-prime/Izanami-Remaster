extends OptionMenu

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer
@export var target_selector: Options

## WORKING VARIABLES
var inventory: Inventory
var selected_gear: Gear

func _ready() -> void:
	Global.description_box_parent = desc_box_container

func load_stock():
	players = Global.player_party
	if players:
		inventory = players.inventory
	update_listing()

func update_listing():
	options.clear()

	if inventory:
		for i in inventory.gear_data:
			options.add_item(
				i,
				str(len(inventory.gear_data[i]))
			)

func show_target_selector():
	target_selector.clear()
	for i in players.party:
		target_selector.add_icon_item(
			i.battle_sprite_texture.texture,
			i.character_name,
			i.gear.gear_dict.head.name if i.gear.gear_dict.head else ' ',
			i.gear.gear_dict.body.name if i.gear.gear_dict.body else ' ',
			i.gear.gear_dict.weapon.name if i.gear.gear_dict.weapon else ' ',
		)

	target_selector.show()
	target_selector.grab_focus()

func choose_target(index: int):
	if players.party[index].gear.check_equipped(selected_gear):
		players.party[index].gear.unequip_gear(selected_gear.slot)
	else:
		players.party[index].gear.equip_gear(selected_gear)
	target_selector.hide()


func _on_item_activated(index: int) -> void:
	selected_gear = inventory.get_entry_by_name(options.get_item_text(index))
	_on_item_selected(index)
	show_target_selector()


func _on_item_selected(index: int) -> void:
	var item = inventory.get_entry_by_name(options.get_item_text(index))
	if item:
		Global.show_description(item)
