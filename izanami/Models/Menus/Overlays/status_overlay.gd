extends Panel

class_name StatusOverlay

@export var player_status_card_scene: PackedScene

@export var player_container: HBoxContainer
@export var target_selector:TargetSelector

func load_menu():
	_clear_data_cards()
	for i in Global.players.party:
		create_card(i)

func create_card(player: Player):
	var card: PlayerStatusCard = player_status_card_scene.instantiate()

	card.nametag.text = player.nametag.text
	card.classname.text = player.classname
	card.icon.texture = player.battle_sprite_texture.texture

	if player == Global.players.leader:
		card.leader_icon.show()

	card.hpbar.value = player.hp_bar.value
	card.hpbar_text.text = player.hp_bar_text.text
	card.spbar.value = player.sp_bar.value
	card.spbar_text.text = player.sp_bar_text.text

	card.stats_str.text = str(player.stats.STR)
	card.stats_int.text = str(player.stats.INT)
	card.stats_wis.text = str(player.stats.WIS)
	card.stats_end.text = str(player.stats.END)
	card.stats_gui.text = str(player.stats.GUI)
	card.stats_agi.text = str(player.stats.AGI)

	var gear: Dictionary = player.gear.gear_dict
	for slot in gear:
		if gear[slot]: card[slot].text = gear[slot].name
		else: card[slot].text = ''

	card.description.text = player.desc

	player_container.add_child(card)

func _clear_data_cards():
	var children = player_container.get_children()
	if children:
		for i in children:
			if is_instance_valid(i):
				i.get_parent().remove_child(i)
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
		target_selector.add_item(i)

	target_selector.show()
	target_selector.player_list.grab_focus()

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


func _on_visibility_changed() -> void:
	if visible:
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
