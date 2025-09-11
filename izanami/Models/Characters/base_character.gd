class_name Base_Character

extends CharacterBody2D

enum STATES {IDLE, WALKING, BATTLE}

@export var state: STATES:
	set(arg):
		state = arg
		state_changed.emit()

@export_category('Handlers')
@export var skills: CharacterSkills
@export var items: CharacterItems
@export var statuses: CharacterStatuses
@export var audio: CharacterAudio

@export_category('UI')
@export var nametag: Label
@export var status_icon_container: GridContainer

@export var hp_bar: ProgressBar
@export var hp_bar_text: Label
@export var sp_bar: ProgressBar
@export var sp_bar_text: Label

@export var pointer: TextureRect
@export var indicator: TextureRect
@export var battle_sprite_texture: TextureRect

@export var original_battle_sprite_control: BattleSprite
@export var battle_sprite: BattleSprite

@export var dungeon_sprite: Sprite2D
@export var hitbox: CollisionShape2D


@export_category('Character Data')
@export var character_name: String
@export var root_stats: Dictionary[StringName, int] = {"STR": 1, "INT": 1, "WIS": 1, "END": 1, "GUI": 1, "AGI": 1}
var base_stats: Dictionary[StringName, int] = root_stats.duplicate()
var stats: Dictionary[StringName, int] = base_stats.duplicate()

@export var level_stats: Array[StringName] = ["STR", "INT", "WIS", "END", "GUI", "AGI"]
@export var desc: String

@export var resistances: Dictionary[StringName, float] = {
	'Physical':	0,
	'Fire':		0,
	'Water':	0,
	'Wind':		0,
	'Dark':		0,
	'Light':	0,
	'Blood':	0,
}

@export var max_hp: int:
	get():
		var _max_hp = (stats['END'] * 10) + (stats['WIS'] * 3) + (lvl * 15)
		if _max_hp > 0:
			return _max_hp
		else:
			return 1

@export var hp: int:
	set(value):
		if value > max_hp: value = max_hp
		hp = value
		_update_hp_bar()

@export var ATK: float = 1
@export var DEF: float = 1
@export var lvl: int = 1
@export var ally: int

var alive: bool = true

signal state_changed

func _ready() -> void:
	load_character()
	statuses.test()

func load_character():
	#stats = base_stats
	#Global.print_to_log(base_stats, ' ', stats)
	update_stats()
	hp = max_hp
	#pointer.set_position(Vector2(0, -130))
	nametag.text = character_name
	skills.load_stock()
	items.load_stock()

	#if ally > 0:
		#pointer.set_texture(load("res://Assets/right_arrow.svg"))
	#else:
		#pointer.set_texture(load("res://Assets/left_arrow.svg"))
	#Global.print_to_log(name, pointer.position)
	#Global.print_to_log(hp)
	#Global.print_to_log("ROOT STATS", root_stats)
	#Global.print_to_log("BASE STATS", base_stats)
	#Global.print_to_log("STATS", stats)
	#Global.print_to_log(skills.get_skills())
	#Global.print_to_log(skills.get_skills()[1].action(self, self))

func _update_hp_bar():
	if hp_bar:
		hp_bar.value = float(hp) / max_hp * 100
		hp_bar_text.text = str(hp, ' / ', max_hp)

func dungeon_display():
	battle_sprite.hide()
	dungeon_sprite.show()

func battle_display():
	battle_sprite.show()
	dungeon_sprite.hide()

func set_acting():
	indicator.show()

func unset_acting():
	indicator.hide()

func target():
	pointer.show()

func untarget():
	pointer.hide()


func assign_ui_element_to_character(ui_object: Control):
	if 'nametag' in ui_object and is_instance_valid(ui_object.nametag):
		ui_object.nametag.text = nametag.text
		nametag = ui_object.nametag

	if 'status_icons' in ui_object and is_instance_valid(ui_object.status_icons):
		status_icon_container = ui_object.status_icons

	if 'battle_sprite_texture' in ui_object and is_instance_valid(ui_object.battle_sprite_texture):
		ui_object.battle_sprite_texture.texture = battle_sprite_texture.texture
		battle_sprite_texture = ui_object.battle_sprite_texture

	if 'dungeon_sprite_texture' in ui_object and is_instance_valid(ui_object.dungeon_sprite_texture):
		#ui_object.dungeon_sprite_texture as Sprite2D
		ui_object.dungeon_sprite_texture.texture = dungeon_sprite.texture
		dungeon_sprite = ui_object.dungeon_sprite

	if 'pointer' in ui_object and is_instance_valid(ui_object.pointer):
		pointer = ui_object.pointer

	if 'indicator' in ui_object and is_instance_valid(ui_object.indicator):
		indicator = ui_object.indicator

	if 'hp_bar' in ui_object and is_instance_valid(ui_object.hp_bar):
		ui_object.hp_bar.value = hp_bar.value
		hp_bar = ui_object.hp_bar

	if 'hp_bar_text' in ui_object and is_instance_valid(ui_object.hp_bar_text):
		ui_object.hp_bar_text.text = hp_bar_text.text
		hp_bar_text = ui_object.hp_bar_text

	if 'sp_bar' in ui_object and is_instance_valid(ui_object.sp_bar):
		ui_object.sp_bar.value = sp_bar.value
		sp_bar = ui_object.sp_bar

	if 'sp_bar_text' in ui_object and is_instance_valid(ui_object.sp_bar_text):
		ui_object.sp_bar_text.text = sp_bar_text.text
		sp_bar_text = ui_object.sp_bar_text

func reset_ui_elements():
	battle_sprite = original_battle_sprite_control

	original_battle_sprite_control.nametag.text = nametag.text
	nametag = original_battle_sprite_control.nametag

	status_icon_container = original_battle_sprite_control.status_icons

	original_battle_sprite_control.battle_sprite_texture.texture = battle_sprite_texture.texture
	battle_sprite_texture = original_battle_sprite_control.battle_sprite_texture

	pointer = original_battle_sprite_control.pointer
	indicator = original_battle_sprite_control.indicator

	original_battle_sprite_control.hp_bar.value = hp_bar.value
	hp_bar = original_battle_sprite_control.hp_bar
	original_battle_sprite_control.hp_bar_text.text = hp_bar_text.text
	hp_bar_text = original_battle_sprite_control.hp_bar_text

	original_battle_sprite_control.sp_bar.value = sp_bar.value
	sp_bar = original_battle_sprite_control.sp_bar
	original_battle_sprite_control.sp_bar_text.text = sp_bar_text.text
	sp_bar_text = original_battle_sprite_control.sp_bar_text


func update_stats():
	for i in root_stats:
		if i in level_stats:
			base_stats[i] = lvl * root_stats[i]

	stats = base_stats.duplicate()


func get_skills(): return skills.get_skills()

func use_skill(skill_id, _target):
	skills.get_skill(skill_id).action(self, _target)


func get_items(): return items.get_items()

func use_item(item_name, _target):
	var item: Item = items.get_item(item_name)
	item.use(_target)
	if not item.reuseable: items.remove_item(item)


func guard():
	DEF *= 2
	Global.print_to_log('%s braces for impact' % [character_name])


func damage(value: float):
	audio.play_damage_sfx()
	value /= DEF
	Global.print_to_log('%s takes %f damage!' % [character_name, value])
	if value < hp:
		hp -= value
	else:
		hp = 0
		die()

func heal(value: float):
	audio.play_heal_sfx()
	hp += value
	Global.print_to_log(' %s healed %f HP' % [character_name, value])


func die():
	audio.play_die_sfx()
	Global.print_to_log('%s is dead' % [character_name])
	alive = false


func save() -> CharacterSaveData:
	var save_data: CharacterSaveData = CharacterSaveData.new()

	save_data.hp = hp
	save_data.lvl = lvl
	save_data.alive = alive
	save_data.position = position
	save_data.scene_file_path = scene_file_path

	return save_data

func load_data(data: CharacterSaveData):
	lvl = data.lvl
	alive = data.alive

	load_character()

	hp = data.hp
	position = data.position
