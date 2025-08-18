extends Node2D

class_name Party

@export var action_menu: Control
@export var skill_panel: Control
@export var source: String
@export var battle_sprite_scene: PackedScene
@export var player_section: Control
@export var player_scene: PackedScene
@export var camera: Camera2D

@export var gold: int
@export var mag: int
@export var dungeon_level: int = 0

@export var inventory: Inventory

var party: Array = []
var leader: Player
var index: int = 0
var frozen: bool = false
var chased: bool = false

var party_panels: Dictionary = {}
var stored_pos: Vector2
var sprites: Array = []

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed('freecam_key'):
		#if frozen:
			#unfreeze()
		#else:
			#freeze()

func _ready() -> void:
	load_party()

func load_party():
	party = get_children().filter(func(x): if x is Player and is_instance_valid(x): return x)
	sprites.clear()
	for i in party:
		# Store battle sprites in array to recall
		sprites.append(i.battle_sprite)
		i.hide()
		i.detector.monitoring = false
		i.hitbox.disabled = true
		#i.listener.clear_current()

	#Checks if there are nodes in the party array, and then checks if there is no leader or if the current leader has been removed from the party
	if len(party) and (not leader or leader not in party):
		leader = party[0]

	if leader:
		leader.show()
		leader.detector.monitoring = true
		leader.hitbox.disabled = false
		leader.listener.make_current()
	#if camera: camera.init_camera()

func switch_leader(_index: int):
	if party[_index] == leader: return

	#for i in leader.detector.get_signal_list():
		#for j in leader.detector.get_signal_connection_list(i.name):
			#print(leader.character_name, j)
	#for i in leader.get_signal_list():
		#for j in leader.get_signal_connection_list(i.name):
			#print(leader.character_name, j)

	var old_leader = leader
	leader = party[_index]

	# Transfer signal connections on old leader to new leader
	for i in old_leader.get_signal_list():
		if i in party[_index].get_signal_list(): continue

		for j in old_leader.get_signal_connection_list(i.name):
			old_leader.disconnect(i.name, j.callable)
			party[_index].connect(i.name, j.callable, j.flags)

	# Transfer signal connections on old leader's detector to new leader
	for i in old_leader.detector.get_signal_list():
		if i in party[_index].detector.get_signal_list(): continue

		for j in old_leader.detector.get_signal_connection_list(i.name):
			old_leader.detector.disconnect(i.name, j.callable)
			party[_index].detector.connect(i.name, j.callable, j.flags)

	#for i in leader.detector.get_signal_list():
		#for j in leader.detector.get_signal_connection_list(i.name):
			#print(leader.character_name, j)
	#for i in leader.get_signal_list():
		#for j in leader.get_signal_connection_list(i.name):
			#print(leader.character_name, j)

	leader.global_position = old_leader.global_position
	old_leader.global_position += Vector2.ONE * 20

	load_party()

func add_to_party(player: Player):
	add_child(player)
	#player.global_position.x += 20 * len(party) # Offset the player to prevent overlap
	load_party()
	player.gear.load_stock()

func remove_from_party(player: Player):
	# Add locked party members
	if len(party) < 2:
		print("Can't remove, party too small")
		return

	if player == leader:
		if player == party[0]:
			switch_leader(1)
		else:
			switch_leader(0)

	remove_child(player)
	load_party()
	player.gear.inventory = null

func warp_players(area: WarpPoint):
		freeze()
		var confirm = await Global.show_confirmation_box("Go to %s" % [area.destination])
		unfreeze()
		if confirm:
			Global.warp(get_tree().current_scene, area.destination_scene)


## BATTLE SCENE
func battle_collision():
	freeze()
	leader.hitbox.set_deferred('disabled', true)
	leader.detector.set_deferred('monitoring', false)
	leader.detector.set_deferred('monitorable', false)

func reset_battle_collision():
	leader.hitbox.set_deferred('disabled', false)
	leader.detector.set_deferred('monitoring', true)
	leader.detector.set_deferred('monitorable', true)


func battle_setup():
	stored_pos = leader.position
	#z_index += 1

	#for i in party:
		#i.show()
		#i.battle_display()

	freeze()

	place_menu()
	place_characters_in_battle()

func battle_reset():
	leader.position = stored_pos
	#z_index -= 1

	for i in party:
		i.dungeon_display()
		i.hide()
		i.statuses.clear_status_all()

	unfreeze()

	revert_menu()

	var valid_sprites := []
	for i in sprites:
		if is_instance_valid(i):
			valid_sprites.append(i)
#
	sprites = valid_sprites
	#print(sprites)

	revert_sprites()

	leader.show()

func place_characters_in_battle():
	for i in party:
		var sprite: BattleSprite = battle_sprite_scene.instantiate()

		#sprite.battle_sprite.texture = i.battle_sprite_texture.texture
		#sprite.nametag.text = i.battle_sprite.nametag.text
		#sprite.hp_bar_text.text = str(i.hp) + ' / ' + str(i.max_hp)
		#sprite.sp_bar_text.text = str(i.sp) + ' / ' + str(i.max_sp)
#
		#i.nametag = sprite.nametag
		#i.status_icons = sprite.status_icons
		#i.hp_bar = sprite.hp_bar
		#i.hp_bar_text = sprite.hp_bar_text
		#i.sp_bar = sprite.sp_bar
		#i.sp_bar_text = sprite.sp_bar_text
		#i.pointer = sprite.pointer
		#i.indicator = sprite.indicator
		#i.battle_sprite_texture = sprite.battle_sprite
#
		#i.battle_sprite = sprite
		i.assign_ui_element_to_character(sprite)

		player_section.add_child(sprite)

		i.battle_display()

func revert_sprites():
	for i in party:
		i.reset_ui_elements()
		#party[i].battle_sprite = sprites[i]
		#party[i].pointer = sprites[i].pointer
		#party[i].indicator = sprites[i].indicator

func place_menu():
	for i in party:
		party_panels.get_or_add(i, [i.item_menu, i.skill_menu])
		#i.item_menu = skill_panel
		#i.skill_menu = skill_panel

func revert_menu():
	for i in party:
		if party_panels.has(i):
			i.item_menu = party_panels[i][0]
			i.skill_menu = party_panels[i][1]

func place_ui():
	pass

func level_up(xp: int):
	xp /= len(party)
	for i in party:
		i.level_up(xp)

# MOVEMENT HANDLING
func freeze():
	frozen = true
	for i in party:
		i.freeze_movement = true

func unfreeze():
	frozen = false
	for i in party:
		i.freeze_movement = false

# SAVING AND LOADING
func save() -> PartySaveData:
	var save_data = PartySaveData.new()

	save_data.dungeon_level = dungeon_level
	save_data.gold = gold
	save_data.mag = mag
	save_data.inventory_data = inventory.save_stock()

	save_data.position = leader.position

	for i in party:
		save_data.players.append(i.save())

	return save_data

func load_state(save_data: PartySaveData):
	dungeon_level = save_data.dungeon_level
	gold = save_data.gold
	mag = save_data.mag

	inventory.load_stock(save_data.inventory_data)


	for i in party:
		remove_child(i)
		i.queue_free()

	for i in save_data.players:
		var player: Player = player_scene.instantiate()
		player.gear.player_gear_data = null
		player.items.item_group = null
		add_to_party(player)
		player.load_data(i)
		#player.freeze_movement = true
		#party[i].load_data(save_data.players[i])

	load_party()
	leader.position = save_data.position
