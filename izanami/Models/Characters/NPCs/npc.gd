extends CharacterBody2D

class_name NPC

@export var cutscenes: Dictionary [StateHandler.STATE, Resource]
@export var battles: Dictionary [StateHandler.STATE, Array]

@export var extra_battle_flags: Dictionary [StateHandler.STATE, PackedStringArray]
@export var battle_set_flags: Dictionary [StateHandler.STATE, SetFlag]

@export var sprite_texture: Texture2D
@export var label: Label
@export var sprite: Sprite2D
@export var path_follow: PathFollow2D

@export var speed: float = 100

var frozen: bool = false
var current_cutscene: JSON

@onready var root_node: Location = get_tree().current_scene

var current_battle: Dictionary [StringName, Variant] = {
	'enemies': [],
	'flags': {}
}

func _ready() -> void:
	if label:
		label.text = name
	if sprite:
		sprite.texture = sprite_texture

func _physics_process(delta: float) -> void:
	if not path_follow: return
	if not frozen: path_follow.progress += speed * delta
	if frozen and not Global.players.frozen: frozen = false


func set_state():
	# Set battle
	if battles.has(Checks.state):
		current_battle.enemies = battles[Checks.state]
		if battle_set_flags.has(Checks.state):
			current_battle.flags = battle_set_flags[Checks.state].data
		else:
			current_battle.flags = {}
	else :
		current_battle = {}

	# Set cutscene
	if cutscenes.has(Checks.state) and not Checks.check_cutscene_played(cutscenes[Checks.state]):
		print(Checks.flags.played_cutscenes)
		current_cutscene = cutscenes[Checks.state]
	else:
		current_cutscene = cutscenes[StateHandler.STATE.DEFAULT]


func play_cutscene():
	frozen = true
	set_state()
	if visible:
		if current_cutscene:
			await Dialogue.show_cutscene(current_cutscene)
		if current_battle:
			if extra_battle_flags.has(Checks.state) and not Checks.check_flags(extra_battle_flags[Checks.state]):
				pass
			else:
				start_battle()

func start_battle():
	LoadingScreen.show()
	var battle: Battle = Global.battle_scene.instantiate()
	battle.rand_spawn = false

	if root_node is Town:
		battle.town = root_node
	elif root_node is Demonitarium:
		battle.demonitarium = root_node

	battle.flags = current_battle.flags
	battle.enemy_set = current_battle.enemies
	battle.forced = true
	root_node.hide()
	root_node.overlay.disable()
	root_node.last_played_cutscene = self
	root_node.call_deferred("add_sibling", battle)
