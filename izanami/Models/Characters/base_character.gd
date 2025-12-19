class_name Base_Character

extends CharacterBody2D

enum STATES {IDLE, WALKING, BATTLE}

@export var state: STATES:
	set(arg):
		state = arg
		set_dungeon_sprite()
		state_changed.emit()

@export_category('Handlers')
@export var skills: CharacterSkills
@export var items: CharacterItems
@export var statuses: CharacterStatuses
@export var audio: CharacterAudio
@export var animation_player: AnimationPlayer

@export_category('UI')
@export var battle_sprite_texture: AnimatedTexture
@export var battle_sprite: Control

@export var status_icon_container: GridContainer
@export var dungeon_sprite: Sprite2D
@export var dungeon_sprite_idle_texture: AnimatedTexture
@export var dungeon_sprite_walk_texture: AnimatedTexture

@export var hitbox: CollisionShape2D

signal indicator_signal(visible: bool)
signal pointer_signal(visible: bool)
signal hp_signal(value: int, text: String)
signal sp_signal(value: int, text: String)

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
		hp_signal.emit((float(hp) / max_hp) * 100, str(hp, ' / ', max_hp))

@export var ATK: float = 1
@export var DEF: float = 1
@export var lvl: int = 1
@export var ally: int

@export var tilemap_position: Vector2i:
	get(): return Vector2i((global_position / Location.TILEMAP_CELL_SIZE).floor())
	set(arg): global_position = (arg * Location.TILEMAP_CELL_SIZE) + Vector2i(8, 15)

var alive: bool = true
var init_pos: Vector2

signal state_changed
signal moved

func _ready() -> void:
	load_character()
	#statuses.test()
	init_pos = global_position

func _process(_delta: float) -> void:
	if is_instance_valid(dungeon_sprite_idle_texture):
		dungeon_sprite_idle_texture.speed_scale = randf_range(3, 5)
	if is_instance_valid(dungeon_sprite_walk_texture):
		dungeon_sprite_walk_texture.speed_scale = randf_range(3, 5)

func _physics_process(_delta: float) -> void:
	if init_pos != global_position:
		if state != STATES.WALKING: state = STATES.WALKING
		if global_position.x < init_pos.x:
			dungeon_sprite.flip_h = true
		elif global_position.x > init_pos.x:
			dungeon_sprite.flip_h = false

		moved.emit()
	else :
		if state != STATES.BATTLE and state != STATES.IDLE: state = STATES.IDLE

	init_pos = global_position


func load_character():
	update_stats()
	hp = max_hp
	skills.load_stock()
	items.load_stock()

func set_dungeon_sprite():
	if not is_instance_valid(dungeon_sprite): return

	match state:
		STATES.IDLE:
			if is_instance_valid(dungeon_sprite_idle_texture):
				dungeon_sprite.texture = dungeon_sprite_idle_texture
			print(dungeon_sprite.texture)
			dungeon_sprite.show()
		STATES.WALKING:
			if is_instance_valid(dungeon_sprite_walk_texture):
				dungeon_sprite.texture = dungeon_sprite_walk_texture
			dungeon_sprite.show()
		STATES.BATTLE:
			dungeon_sprite.hide()



func dungeon_display():
	dungeon_sprite.show()

func battle_display():
	if state != STATES.BATTLE: state = STATES.BATTLE

func set_acting():
	indicator_signal.emit(true)

func unset_acting():
	indicator_signal.emit(false)

func target():
	pointer_signal.emit(true)

func untarget():
	pointer_signal.emit(false)

func assign_ui_element_to_character(ui_object: Control):
	battle_sprite = ui_object
	if 'nametag' in ui_object and is_instance_valid(ui_object.nametag):
		ui_object.nametag.text = character_name

	if 'status_icons' in ui_object and is_instance_valid(ui_object.status_icons):
		status_icon_container = ui_object.status_icons

	if 'sprite' in ui_object and is_instance_valid(ui_object.sprite):
		ui_object.sprite.texture = battle_sprite_texture

	if 'pointer' in ui_object and is_instance_valid(ui_object.pointer):
		pointer_signal.connect(ui_object._set_pointer)

	if 'indicator' in ui_object and is_instance_valid(ui_object.indicator):
		indicator_signal.connect(ui_object._set_indicator)

	if 'hp_bar' in ui_object and is_instance_valid(ui_object.hp_bar):
		ui_object.hp_bar.value = (float(hp) / max_hp) * 100
		ui_object.hp_bar_text.text = str(hp, ' / ', max_hp)
		hp_signal.connect(ui_object._update_hp_bar)

func reset_ui_elements():
	status_icon_container = $Statuses/GridContainer

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
	animation_player.play("hit")
	if is_instance_valid(battle_sprite) and 'animation_player' in battle_sprite:
		battle_sprite.animation_player.play("hit")
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
