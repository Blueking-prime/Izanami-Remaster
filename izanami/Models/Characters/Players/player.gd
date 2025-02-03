extends Base_Character

class_name Player

## CHILD NODES
@onready var gear: Node = $Gear
@onready var detector: Area2D = $Detector

@export var skill_menu: ItemList
@export var item_menu: ItemList


## DYNAMIC PROPERTIES
@export var max_sp: int:
	get():
		return (stats['AGI'] + stats['END']) * 3

@export var sp: int:
	set(value):
		sp = value
		_update_sp_bar()

## STATIC PROPERTIES
@export var xp: int = 0
@export var level_up_xp: int = 50 * (2 ** lvl)
@export var mag: int = 0
@export var level_stats: Array = []
@export var level_cap: int = 60

## LOGIC VARIABLES
@export var speed = 50.0

## STATES
var active_selection
var chosen_option: bool = false
var freeze_movement: bool = false

## SIGNALS
#signal hit_chest
#signal hit_enemy
#signal hit_exit


func _ready() -> void:
	ally = 1
	sp = max_sp
	super()
	_display_skills()
	_display_items()


func _physics_process(_delta):
	# Get input
	if not freeze_movement:
		var direction = Vector2()
		direction = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')

		if direction.length():
			direction = direction.normalized()
			velocity = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)

		move_and_slide()




## MODIFY PROPERTIES
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
	print(name, " gained ", xp, "EXP")
	if xp < level_up_xp:
		return

	if lvl >= level_cap:
		return

	print(name, " leveled up!")
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



## CHILD NODE FUNCTIONS
### SP
func _update_sp_bar():
	if sp_bar:
		sp_bar.value = (sp / max_sp) * 100
		sp_bar_text.text = str(sp, ' / ', max_sp)

func consume_sp(value: float):
	#print('sp', sp)
	if sp <= 0:
		print('Out of SP')
		return false
	sp -= value
	#print('sp ', sp)
	return true


### SKILLS
func _display_skills():
	skill_menu.clear()
	for i in get_skills():
		skill_menu.add_item(i.name)

func show_skill_menu():
	skill_menu.show()
	skill_menu.item_selected.connect(_on_skill_list_selected)
	_display_skills()
	skill_menu.grab_focus()

func _on_skill_list_selected(index: int) -> void:
	if Global.description_box:
		Global.description_box.queue_free()
	Global.show_description(get_skills()[index])
	Global.description_box.size_flags_stretch_ratio = 2


### ITEMS
func _display_items():
	item_menu.clear()
	var _items = get_items()
	for i in _items:
		item_menu.add_item(i)
		item_menu.add_item(str(len(_items[i])))

func show_item_menu():
	item_menu.show()
	item_menu.item_selected.connect(_on_item_list_selected)
	_display_items()
	item_menu.grab_focus()

func use_item(item_name, _target):
	if item_name is int:
		item_name = item_menu.get_item_text(active_selection)
	super.use_item(item_name, _target)
	_display_items()

func _on_item_list_selected(index: int) -> void:
	if Global.description_box:
		Global.description_box.queue_free()
	Global.show_description(items.get_item(item_menu.get_item_text(index)))
	Global.description_box.size_flags_stretch_ratio = 2


### UI DISPLAYS
func reset_menu():
	#item_menu.hide()
	#skill_menu.hide()
	active_selection = null
	chosen_option = false


## END OF TURN EFFECTS
func restore():
	sp += stats['END'] * 2
	if sp > max_sp:
		sp = max_sp

func status():
	super.status()
	if sp < 0:
		status_effect = 'EnExhaust'
	if status_effect == 'EnExhaust':
		sp -= max_sp / 4

func die():
	print('And so you fall, your journey never to be completed')
	super.die()
## Add death screen and shit


## MISC SIGNALS
func _on_gear_gear_change() -> void:
	update_stats()
	#print(stats, hp, max_hp, sp, max_sp)


#func _on_detector_object_hit(object_type: Variant) -> void:
	#print(object_type, ' hit')
	#emit_signal('object_hit', object_type)
