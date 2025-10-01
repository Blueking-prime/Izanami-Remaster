extends Node


@export var flags: Flags
@export var settings_flags: SettingsFlags

@export var custom_seed: int = 0
var current_quest: GlobalQuests.Quest
var refresh_shops: bool = false
var player_name: String = 'Magnolia'


func check_flags(flags: Array) -> bool:
	return flags.all(func(x): return flags.get(x))

func set_flags(flags: Dictionary):
	for i in flags:
		flags.set(i, flags[i])
	Global.update_quests()


#region QUESTS
var completed_quests: Array


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

func save() -> Dictionary:
	var flag_data: Array = flags.get_script().get_script_property_list()
	flag_data = flag_data.filter(
		func(x): return x.name.ends_with('.gd') == false
	).map(
		func(x): return {'name': x.name, 'value': flags.get(x.name)}
	)

	var settings_data: Array = settings_flags.get_script().get_script_property_list()
	settings_data = settings_data.filter(
		func(x): return x.name.ends_with('.gd') == false
	).map(
		func(x): return {'name': x.name, 'value': settings_flags.get(x.name)}
	)

	return {'flag_data': flag_data, 'settings_data': settings_data}


func load_checks(save_data: Dictionary):
	for i in save_data.flag_data:
		flags.set(i.name, i.value)

	for i in save_data.settings_data:
		settings_flags.set(i.name, i.value)
