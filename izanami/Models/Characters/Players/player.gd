extends Base_Character

class_name Player

@onready var sp_bar: ProgressBar = $SPBar
@onready var sp_bar_text: Label = $SPBar/Label
@onready var gear: Node = $Gear
@onready var inventory: Node = $Inventory
@onready var skill_menu: ItemList = $Skills/SkillList
@onready var item_menu: ItemList = $Items/ItemList

# Player stats
@export var max_sp: float:
	get():
		return (stats['AGI'] + stats['END']) * 3

@export var sp: float:
	set(value):
		sp = value
		_update_sp_bar()

@export var xp: int = 0
@export var gold: int = 0
@export var level_up_xp: int = 50 * (2 ** lvl)
@export var mag: int = 0
@export var level_stats: Array = []

var active_selection
var chosen_option: bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ally = 1
	sp = max_sp
	super()
	_display_skills()
	_display_items()

func _update_sp_bar():
	if sp_bar:
		sp_bar.value = (sp / max_sp) * 100
		sp_bar_text.text = str(sp, ' / ', max_sp)

func restore():
	sp += stats['END'] * 2
	if sp > max_sp:
		sp = max_sp

#func act(action: str, inst: str, target):
	#x = super().act(action, inst, target)
	#if x:
		#return x
	#if action == 'Items':
		#return use_items(inst, target)
	#return x


func update_stats():
	var current_max = [max_hp, max_sp]

	for i in stats:
		stats[i] = base_stats[i] + $Gear.stats[i]

	update_derived_stats(current_max)

func update_derived_stats(current_max: Array):
	hp = (hp/current_max[0]) * max_hp
	sp = (sp/current_max[1]) * max_sp

func level_up(value):
	xp += value
	if xp < level_up_xp:
		return

	var current_max = [max_hp, max_sp]
	var curr_stats = base_stats

	xp -= level_up_xp
	lvl += 1

	for i in level_stats:
		curr_stats[i] += 1
	
	base_stats = curr_stats

	update_derived_stats(current_max)
	level_up_xp = 50 * (2 ** lvl)
	skills.update_skills()
	_display_skills()


func status():
	super.status()
	if sp < 0:
		status_effect = 'EnExhaust'
	if status_effect == 'EnExhaust':
		sp -= max_sp / 4

func move(map: Node):
	var x = map.player_pos[0]
	var y = map.player_pos[1]
	if Input.is_action_just_pressed("ui_down"):
		map.player_pos = [x, y - 1]
	if Input.is_action_just_pressed("ui_down"):
		map.player_pos = [x, y + 1]
	if Input.is_action_just_pressed("ui_down"):
		map.player_pos = [x - 1, y]
	if Input.is_action_just_pressed("ui_down"):
		map.player_pos = [x + 1, y]

func consume_sp(value: float):
	#print('sp', sp)
	if sp <= 0:
		print('Out of SP')
		return false
	sp -= value
	#print('sp ', sp)
	return true


func _display_skills():
	skill_menu.clear()
	for i in get_skills():
		skill_menu.add_item(i.name)

func show_skill_menu():
	skill_menu.show()
	skill_menu.grab_focus()


func _display_items():
	item_menu.clear()
	var _items = get_items()
	for i in _items:
		item_menu.add_item(i)
		item_menu.add_item(str(_items[i]))

func show_item_menu():
	item_menu.show()
	item_menu.grab_focus()

func use_item(item_name, target):
	super.use_item(item_name, target)
	_display_items()

func reset_menu():
	item_menu.hide()
	skill_menu.hide()
	active_selection = null
	chosen_option = false

func die():
	print('And so you fall, your journey never to be completed')
	super.die()
## Add death screen and shit


func _on_gear_gear_change() -> void:
	update_stats()
	#print(stats, hp, max_hp, sp, max_sp)


func _on_skill_list_activated(index: int) -> void:
	active_selection = index
	chosen_option = true


func _on_item_list_activated(index: int) -> void:
	active_selection = item_menu.get_item_text(index)
	chosen_option = true
