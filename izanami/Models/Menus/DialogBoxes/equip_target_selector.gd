extends Options

class_name EquipTargetSelector

func add_player_data(player: Player):
	add_icon_item(
		player.battle_sprite_texture.texture,
		player.character_name,
		player.gear.gear_dict.head.name if player.gear.gear_dict.head else ' ',
		player.gear.gear_dict.weapon.name if player.gear.gear_dict.weapon else ' ',
		player.gear.gear_dict.body.name if player.gear.gear_dict.body else ' '
	)
