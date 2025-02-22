extends Control

class_name EquipTargetSelector

@export var player_list: ItemList
@export var head_slot_list: ItemList
@export var weapon_slot_list: ItemList
@export var body_slot_list: ItemList

signal item_activated(index: int)

func clear():
	player_list.clear()
	head_slot_list.clear()
	weapon_slot_list.clear()
	body_slot_list.clear()

func add_item(player: Player):
	player_list.add_item(player.character_name, player.battle_sprite_texture.texture)
	head_slot_list.add_item(player.gear.gear_dict.head.name if player.gear.gear_dict.head else ' ', null, false)
	weapon_slot_list.add_item(player.gear.gear_dict.weapon.name if player.gear.gear_dict.weapon else ' ', null, false)
	body_slot_list.add_item(player.gear.gear_dict.body.name if player.gear.gear_dict.body else ' ', null, false)

func _on_player_item_activated(index: int) -> void:
	item_activated.emit(index)
