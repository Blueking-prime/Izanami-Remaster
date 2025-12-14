extends Control

class_name TargetSelector

@export var player_list: ItemList

signal item_activated(index: int)

func clear():
	player_list.clear()

func add_item(player: Player):
	player_list.add_item(player.character_name, player.battle_sprite_texture)

func _on_player_item_activated(index: int) -> void:
	item_activated.emit(index)
