extends Node

class_name BattleTurns

@export var turncount_label: Label
@export var turn_order_display: HBoxContainer

@onready var process_input: BattleInput = get_parent().process_input
@onready var setup: BattleSetup = get_parent().setup

## WORKING VARIABLES
var actors: Array = []
var turn_order: Array = []
var enemy_array: Array = []
var player_array: Array = []

var turncount: int = 1
var current_player: Player
var actor: Base_Character
var idx: int = 0


func act():
	if check_if_players_all_dead():
		# Run game over
		end_battle()

	if not actor:
		actor = turn_order[0]

	fill_turn_count_display()
	highlight_current_actor()

	actor.set_acting()

	if not actor.alive:
		advance_actor()
		return

	actor.statuses.status()
	if actor.statuses.stunned:
		print('%s is stunned' % [actor.character_name])
		advance_actor()
		return

	#print(actor.character_name)
	#actor.focus()
	if actor is Enemy:
		process_input.input_disabled = true
		await actor.battle_ai(player_array, enemy_array)
		advance_actor()
	else:
		process_input.input_disabled = false
		current_player = actor
		process_input.show_choice()

		#actor.unfocus()

func advance_actor():
	process_input.reset_target()
	actor.unset_acting()

	#Check if enemies were one-shot basically
	if check_if_enemies_all_dead():
		kill_enemies()
		end_battle()

	idx += 1
	if idx >= actors.size():
		end_turn()

	actor = turn_order[idx]
	act()

func kill_enemies():
	for i in enemy_array:
		if not i.alive:
			get_parent().earned_exp += i.exp_drop()
			get_parent().earned_gold += i.gold_drop()
			enemy_array.erase(i)
			turn_order.erase(i)
			actors.erase(i)
			i.queue_free()

func check_if_enemies_all_dead():
	for i in enemy_array:
		if i.alive:
			return false
	return true

func check_if_players_all_dead():
	for i in player_array:
		if i.alive:
			return false
	return true

func end_turn():
	idx = 0
	turncount += 1

	kill_enemies()

	if not len(enemy_array):
		end_battle()

	turncount_label.text = str(turncount)

func end_battle():
	setup.exit_battle("win")

func fill_turn_count_display():
	for i in turn_order_display.get_children():
		turn_order_display.remove_child(i)
		i.queue_free()

	for i in turn_order:
		if i.alive:
			turn_order_display.add_child(create_turn_count_icon(i))

func create_turn_count_icon(entity: Base_Character) -> PanelContainer:
	var panel_container: PanelContainer = PanelContainer.new()
	var texture: TextureRect = TextureRect.new()
	texture.texture = entity.battle_sprite_texture
	texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	texture.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL
	texture.scale = Vector2(0.5, 0.5)
	panel_container.add_child(texture)
	panel_container.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	panel_container.size_flags_vertical = Control.SIZE_EXPAND_FILL

	return panel_container

func highlight_current_actor():
	pass

#func enemy_attack_script_placeholder():
	#var target_player = randi_range(0, player_array.size() - 1)
	#var skill_id = randi_range(0, actor.get_skills().size() - 1)
	##player_array[target_player].focus()
	#if actor.get_skills()[skill_id].aoe:
		#actor.use_skill(skill_id, player_array)
	#else:
		#actor.use_skill(skill_id, player_array[target_player])
	#print('from ', actor.name)
	##player_array[target_player].unfocus()
	#advance_actor()

#
#func _on_battle_ready() -> void:
	#act()
