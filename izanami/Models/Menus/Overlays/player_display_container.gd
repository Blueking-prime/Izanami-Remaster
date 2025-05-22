extends VBoxContainer

@export var data_card_scene: PackedScene

func display_player_data():
	_clear_data_cards()
	var players: Party = Global.players
	_spawn_player_card(players.leader)
	for i in players.party:
		if i != players.leader:
			add_spacer(false)
			_spawn_player_card(i)

func _spawn_player_card(player: Player):
	var data: PlayerDataCard = data_card_scene.instantiate()

	data.nametag.text = player.nametag.text
	data.sprite.texture = player.battle_sprite_texture.texture
	data.nametag.text = player.battle_sprite.nametag.text
	data.hp_bar_text.text = str(player.hp) + '/' + str(player.max_hp)
	data.sp_bar_text.text = str(player.sp) + '/' + str(player.max_sp)

	player.battle_sprite_texture = data.sprite
	player.nametag = data.nametag
	player.hp_bar = data.hp_bar
	player.hp_bar_text = data.hp_bar_text
	player.sp_bar = data.sp_bar
	player.sp_bar_text = data.sp_bar_text

	add_child(data)

func _clear_data_cards():
	var children = get_children()
	if children:
		for i in children:
			remove_child(i)
			i.queue_free()
