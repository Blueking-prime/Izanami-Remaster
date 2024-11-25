extends Node2D

var actors: Array = []
var turn_order: Array = []
var enemy_array: Array = []
var player_array: Array = []
var is_battling: bool = false
var index: int = 0
var idx: int = 0
var current_actor
var flag: StringName
@onready var choice = $CanvasLayer/Actions
@onready var players = $Players
@onready var enemies = $Enemies

func _ready() -> void:
	player_array = players.players
	enemy_array = enemies.enemies
	actors = player_array + enemy_array
	turn_order = actors.slice(0)
	turn_order.sort_custom(func(a, b): return a.stats['AGI'] > b.stats['AGI'])
	print(turn_order)
	

func _process(_delta: float) -> void:
	if not choice.visible:
		#if is_instance_of(actors[index], Player):
		if Input.is_action_just_pressed("ui_up"):
			if index > 0:
				index -= 1
				switch_focus(index, index + 1)
		if Input.is_action_just_pressed("ui_down"):
			if index < actors.size() - 1:
				index += 1
				switch_focus(index, index - 1)
		if Input.is_action_just_pressed("ui_accept"):
			_action()

	act(turn_order[idx])

func _action():
	print(current_actor, ' is acting')
	#print(current_actor.stats)
	match flag:
		'Attack': use_basic_attack()
		'Skills': use_skills()
		'Items': use_items()
		'Guard': use_guard()
		'Run': use_run()
		
	is_battling = false
	choice.hide()
	idx += 1
	if idx >= 6:
		idx = 0

func act(actor: Base_Character):
	current_actor = actor
	current_actor.focus()
	if not is_battling:
		print(actor.name)
		#actor.focus()
		if is_instance_of(actor, Enemy):
			var target_player = randi_range(0, player_array.size() - 1)
			var skill_id = randi_range(0, actor.get_skills().size() - 1)
			#player_array[target_player].focus()
			actor.use_skill(skill_id, player_array[target_player])
			print('from ', actor.name)
			#player_array[target_player].unfocus()
			idx += 1
			if idx >= 6:
				idx = 0
		else:
			is_battling = true
			show_choice()
		
		#actor.unfocus()

func switch_focus(x, y):
	actors[x].focus()
	actors[y].unfocus()

func show_choice():
	choice.show()
	choice.find_child("Attack").grab_focus()
	
func _reset_focus():
	index = 0
	for actor in actors:
		actor.unfocus()

func _start_choosing():
	_reset_focus()
	actors[index].focus()

func _on_attack_pressed() -> void:
	flag = 'Attack'
	choice.hide()
	_start_choosing()


func _on_guard_pressed() -> void:
	pass # Replace with function body.


func _on_run_pressed() -> void:
	pass # Replace with function body.


func _on_skills_pressed() -> void:
	flag = 'Skills'
	choice.hide()
	_start_choosing()


func _on_items_pressed() -> void:
	pass # Replace with function body.

func use_basic_attack():
	current_actor.use_skill(0, actors[index])

func use_skills():
	var skills = current_actor.get_skills()
	print(skills)

func use_guard():
	pass

func use_run():
	pass

func use_items():
	pass
