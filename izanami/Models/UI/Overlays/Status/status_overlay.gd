extends Panel

class_name StatusOverlay

@export var player_status_card_scene: PackedScene

@export var player_container: HBoxContainer
@export var target_selector: Options

signal refresh_details_display

func load_menu():
	#_clear_data_cards()
	var cards = _get_card_holders()
	for i in Global.players.party:
		if i in cards.keys():
			update_cards(cards[i], i)
			cards.erase(i)
		else:
			create_card(i)

	_clear_data_cards(cards)

func _get_card_holders() -> Dictionary:
	var card_holder_list = {}
	for i in player_container.get_children():
		card_holder_list.get_or_add(i.player, i)
	return card_holder_list

func create_card(player: Player):
	var card: PlayerStatusCard = player_status_card_scene.instantiate()

	card.player = player
	player_container.add_child(card)
	card.player_removed.connect(_refresh_display)

	update_cards(card, player)

func update_cards(card: PlayerStatusCard, player: Player):
	card.nametag.text = player.character_name
	card.classname.text = player.classname
	card.icon.texture = player.battle_sprite_texture

	if player == Global.players.leader:
		card.leader_icon.show()
	else:
		card.leader_icon.hide()

	player.assign_ui_element_to_character(card)
	card.remove_button.visible = not player.lock

	var gear: Dictionary = player.gear.gear_dict
	for slot in gear:
		if gear[slot]: card[slot].text = gear[slot].name
		else: card[slot].text = ''

	card.description.text = player.desc

func _clear_data_cards(children: Dictionary = {}):
	if children:
		for i in children.values():
			if is_instance_valid(i):
				player_container.remove_child(i)
				i.queue_free()


func _on_exit_button_pressed() -> void:
	Global.exit_signal.disconnect(_on_exit_button_pressed)
	Global.exit_button.hide()
	Global.players.unfreeze()
	target_selector.hide()
	hide()

func show_target_selector():
	target_selector.clear()
	for i in Global.players.party:
		target_selector.add_icon_item(i.battle_sprite_texture, i.character_name)

	target_selector.show()
	target_selector.grab_focus()

func choose_target(index: int):
	Global.players.switch_leader(index)
	Global.players.load_party()
	load_menu()
	target_selector.hide()

func _on_switch_button_pressed() -> void:
	if visible:
		if target_selector.visible:
			target_selector.hide()
		else:
			show_target_selector()

func _refresh_display():
	refresh_details_display.emit()

func _on_visibility_changed() -> void:
	Audio.quiet(visible)
	Audio.play_show_menu_sfx(visible)
	if visible:
		Global.players.freeze()
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
		Global.exit_button.show()
	else:
		if is_instance_valid(Global.exit_button): Global.exit_button.hide()
		if is_instance_valid(Global.players): Global.players.unfreeze()
