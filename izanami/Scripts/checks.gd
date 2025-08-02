extends Node


@export var custom_seed: int = 0

#// SETTINGS FLAGS //#
# Text settings
@export var scroll: bool = true
@export var scroll_speed: float = 0.05
@export var ffwd_speed: float = 0.3
@export var wait_time: float = 1
@export var input_type: int = 0

var refresh_shops: bool = false

var dungeons: Dictionary = {
	'test': {
		'level': 2
	}
}

## Menu persistance
var inventory_tab: int = 0
var battle_option: Dictionary = {}
var skill_option: Dictionary = {}
var item_option: Dictionary = {}

## PERSISTENCE HANDLING
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

func save():
	pass

func load():
	pass
