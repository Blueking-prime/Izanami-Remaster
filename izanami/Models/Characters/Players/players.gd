extends Node2D

class_name Party

@export var action_menu: Control
@export var skill_panel: Control
@export var source: String
@export var battle_sprite_scene: PackedScene
@export var player_section: Control

@export var gold: int
@export var mag: int
@export var dungeon_level: int = 1

@export var inventory: Inventory

var party: Array = []
var leader: Player
var index: int = 0

var party_panels: Dictionary = {}
var stored_pos: Vector2
var sprites: Array = []

func _ready() -> void:
	party = get_children().filter(func(x): if x is Player: return x)
	for i in party:
		# Store battle sprites in array to recall
		sprites.append(i.battle_sprite)
		i.hide()
	leader = party[0]
	leader.show()


## BATTLE SCENE
func battle_setup():
	stored_pos = leader.position
	z_index += 1

	#for i in party:
		#i.show()
		#i.battle_display()

	freeze()

	place_menu()
	place_characters_in_battle()

func battle_reset():
	leader.position = stored_pos
	z_index -= 1

	for i in party:
		i.dungeon_display()
		i.hide()

	unfreeze()

	revert_menu()
	revert_sprites()

	leader.show()


func place_characters_in_battle():
	for i in party:
		var sprite: BattleSprite = battle_sprite_scene.instantiate()

		sprite.battle_sprite.texture = i.battle_sprite_texture.texture
		sprite.nametag.text = i.battle_sprite.nametag.text
		sprite.hp_bar_text.text = str(i.hp) + ' / ' + str(i.max_hp)
		sprite.sp_bar_text.text = str(i.sp) + ' / ' + str(i.max_sp)

		i.nametag = sprite.nametag
		i.hp_bar = sprite.hp_bar
		i.hp_bar_text = sprite.hp_bar_text
		i.sp_bar = sprite.sp_bar
		i.sp_bar_text = sprite.sp_bar_text
		i.pointer = sprite.pointer
		i.indicator = sprite.indicator
		i.battle_sprite_texture = sprite.battle_sprite

		i.battle_sprite = sprite

		player_section.add_child(sprite)

		i.battle_display()

func revert_sprites():
	for i in len(party):
		party[i].battle_sprite = sprites[i]
		party[i].pointer = sprites[i].pointer
		party[i].indicator = sprites[i].indicator

func place_menu():
	for i in party:
		party_panels.get_or_add(i, [i.item_menu, i.skill_menu])
		i.item_menu = skill_panel
		i.skill_menu = skill_panel

func revert_menu():
	for i in party:
		i.item_menu = party_panels[i][0]
		i.skill_menu = party_panels[i][1]

func place_ui():
	pass

func level_up(xp: int):
	xp /= len(party)
	for i in party:
		i.level_up(xp)

func freeze():
	for i in party:
		i.freeze_movement = true

func unfreeze():
	for i in party:
		i.freeze_movement = false
