extends Base_Character

class_name Player

## CHILD NODES
@export var gear: PlayerGear
@export var detector: PlayerDetector

@export var skill_menu: Options
@export var item_menu: Options

## DYNAMIC PROPERTIES
@export var max_sp: int:
	get():
		var _max_sp = (stats['AGI'] + stats['END']) * 3
		if _max_sp > 0:
			return _max_sp
		else:
			return 1

@export var sp: int:
	set(value):
		sp = value
		_update_sp_bar()

@export var level_up_xp: int:
	get():
		return 50 * (2 ** lvl)

## STATIC PROPERTIES
@export var xp: int = 0
@export var mag: int = 0

## CONSTANTS
@export var level_cap: int = 60
@export var speed: int = 50
@export var classname: StringName

## STATES
var active_selection
var freeze_movement: bool = false

## SIGNALS
signal moved
#signal hit_chest
#signal hit_enemy
#signal hit_exit

func load_character():
	ally = 1
	sp = max_sp
	super.load_character()
	gear.load_stock()
	_display_skills()
	_display_items()


func _physics_process(delta: float) -> void:
	if not freeze_movement:
		var direction = Vector2()
		direction = Input.get_vector('ui_left', 'ui_right', 'ui_up', 'ui_down')

		if direction.length():
			direction = direction.normalized()
			velocity = direction * speed * delta * 1000
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
			velocity.y = move_toward(velocity.y, 0, speed)

		get_real_velocity()
		move_and_slide()
		moved.emit()

## MODIFY PROPERTIES
func update_stats():
	var current_max = [max_hp, max_sp]

	super.update_stats()
	for i in stats:
		stats[i] = base_stats[i] + $Gear.stats[i]

	update_derived_stats(current_max)

func update_derived_stats(current_max: Array):
	hp = int((float(hp)/current_max[0]) * max_hp)
	sp = int((float(sp)/current_max[1]) * max_sp)

func level_up(value):
	xp += value
	Global.print_to_log(character_name + " gained " + str(xp) + "EXP")
	if xp < level_up_xp:
		return

	if lvl >= level_cap:
		return

	Global.print_to_log(character_name + " leveled up!")

	xp -= level_up_xp
	lvl += 1

	update_stats()
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
	#Global.print_to_log('sp', sp)
	if sp <= 0:
		Global.print_to_log('Out of SP')
		return false
	sp -= value
	#Global.print_to_log('sp ', sp)
	return true


### SKILLS
func _display_skills():
	skill_menu.clear()
	for i in get_skills():
		skill_menu.add_item(i.name, [str(i.cost)])

func show_skill_menu():
	skill_menu.show()
	skill_menu.item_selected.connect(_on_skill_list_selected)
	_display_skills()
	skill_menu.grab_focus()

func _on_skill_list_selected(index: int) -> void:
	Global.show_description(get_skills()[index])
	Global.description_box.size_flags_stretch_ratio = 2


### ITEMS
func _display_items():
	item_menu.clear()
	var _items = get_items()
	for i in _items:
		item_menu.add_item(i, [str(len(_items[i]))])

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
	Global.show_description(items.get_item(item_menu.get_item_text(index)))
	Global.description_box.size_flags_stretch_ratio = 2


### UI DISPLAYS
func reset_menu():
	item_menu.clear()
	skill_menu.clear()
	active_selection = null
	if is_instance_valid(Global.description_box):
		Global.description_box.queue_free()


func die():
	Global.print_to_log('And so you fall, your journey never to be completed')
	super.die()
## Add death screen and shit

func save() -> CharacterSaveData:
	var save_data: PlayerSaveData = PlayerSaveData.new()

	save_data.hp = hp
	save_data.lvl = lvl
	save_data.alive = alive

	save_data.character_name = character_name
	save_data.sp = sp
	save_data.xp = xp
	save_data.gear = gear.save()

	return save_data

func load_data(data: CharacterSaveData):
	data = data as PlayerSaveData

	xp = data.xp
	items.item_group = null
	gear.player_gear_data = data.gear
	character_name = data.character_name

	super.load_data(data)

	sp = data.sp

#func _on_detector_object_hit(object_type: Variant) -> void:
	#Global.print_to_log(object_type, ' hit')
	#emit_signal('object_hit', object_type)
