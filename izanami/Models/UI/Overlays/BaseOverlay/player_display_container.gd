extends VBoxContainer

class_name PlayerDataDisplay

@export var data_card_scene: PackedScene

func display_player_data():
	_clear_data_cards()
	var cards = _get_card_holders()
	for i in Global.players.party:
		if i in cards.keys():
			update_card(cards[i], i)
			cards.erase(i)
		else:
			if get_child_count():
				add_spacer(false)
			_spawn_player_card(i)

	_clear_data_cards(cards)

func _get_card_holders() -> Dictionary:
	var card_holder_list = {}
	for i in get_children():
		if i is PlayerDataCard:	card_holder_list.get_or_add(i.player, i)
	return card_holder_list


func _spawn_player_card(player: Player):
	var data: PlayerDataCard = data_card_scene.instantiate()
	data.player = player
	update_card(data, player)
	add_child(data)


func update_card(data: PlayerDataCard, player: Player):
	player.assign_ui_element_to_character(data)


func _clear_data_cards(children: Dictionary = {}):
	if children:
		for i in children.values():
			if is_instance_valid(i):
				remove_child(i)
				i.queue_free()
