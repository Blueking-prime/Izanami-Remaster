extends Node2D

var actors: Array = []
var turn_order: Array = []
var enemy_array: Array = []
var player_array: Array = []
var is_battling: bool = false
var index: int = 0
var idx: int = 0

@onready var choice = $CanvasLayer/Actions

func _ready() -> void:
	player_array = $Players.players
	enemy_array = $Enemies.enemies
	actors = player_array + enemy_array
	turn_order = actors.slice(0)
	turn_order.sort_custom(func(a, b): return a.stats['AGI'] > b.stats['AGI'])
	
	act(turn_order[0])
	
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
	actors[index].damage(3)
	is_battling = false
	choice.hide()

func act(actor: Base_Character):
	if not is_battling:
		print(actor.name)
		#actor.focus()
		if is_instance_of(actor, Enemy):
			var target_player = randi_range(0, player_array.size() - 1)
			#player_array[target_player].focus()
			player_array[target_player].damage(3)
			print('from ', actor.name)
			#player_array[target_player].unfocus()
		else:
			is_battling = true
			show_choice()
		
		idx += 1
		if idx >= 6:
			idx = 0
		
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
	actors[0].focus()

func _on_attack_pressed() -> void:
	choice.hide()
	_start_choosing()
