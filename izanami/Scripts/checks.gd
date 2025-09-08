extends Node

@export var custom_seed: int = 0

var current_quest: GlobalQuests.Quest
var refresh_shops: bool = false

var main_check: bool = true:
	set(arg): main_check = _set_flag(arg)
var main_flag: bool = false:
	set(arg): main_flag = _set_flag(arg)
var hidden_flag: bool = false:
	set(arg): hidden_flag = _set_flag(arg)
var another_flag: bool = true:
	set(arg): another_flag = _set_flag(arg)
var alt_flag: bool = true:
	set(arg): alt_flag = _set_flag(arg)



#region QUESTS
var completed_quests: Array

var apothecary_visit: bool = false:
	set(arg): apothecary_visit = _set_flag(arg)
var smithy_buy: bool = false:
	set(arg): smithy_buy = _set_flag(arg)
var test_return: bool = false:
	set(arg): test_return = _set_flag(arg)
var meander: bool = false:
	set(arg): meander = _set_flag(arg)

func _set_flag(arg):
	if arg:
		Global.update_quests()
	return arg
#endregion

#// SETTINGS FLAGS //#
# Text settings
#region TEXT SETTINGS
@export var scroll: bool = true
@export var scroll_speed: float = 0.05
@export var ffwd_speed: float = 0.3
@export var wait_time: float = 1
@export var input_type: int = 0
@export var thought_text_colour: Color
@export var small_text_size: int = 10
#endregion


var dungeons: Dictionary = {
	'test': {
		'level': 2
	}
}

#region PERSISTENCE HANDLING
## Menu persistance
var inventory_tab: int = 0
var quests_tab: int = 0
var battle_option: Dictionary = {}
var skill_option: Dictionary = {}
var item_option: Dictionary = {}

func set_action_persistence(_key: Variant, _id: int):
	if _key in battle_option:
		battle_option[_key] = _id
	else :
		battle_option.get_or_add(_key, _id)

func set_skill_persistence(_key: Variant, _id: int):
	if _key in skill_option:
		skill_option[_key] = _id
	else :
		skill_option.get_or_add(_key, _id)

func set_item_persistence(_key: Variant, _id: int):
	if _key in item_option:
		item_option[_key] = _id
	else :
		item_option.get_or_add(_key, _id)

func clean_persistence():
	for i in battle_option:
		if i not in Global.players.party:
			battle_option.erase(i)

	for i in skill_option:
		if i not in Global.players.party:
			skill_option.erase(i)

	for i in item_option:
		if i not in Global.players.party:
			item_option.erase(i)
#endregion

func save():
	#var props = get_script().get_script_property_list()
	#for prop in props:
		#print("name: ", prop.name, ", value: ", get(prop.name), ", type: ", prop.type)
	pass

func load():
	pass
