extends Node

class_name StateHandler

enum STATE {
	DEFAULT,
	BEGIN,
	POST_KINTA,
	POST_WEST_TOWER,
	POST_SOUTH_TOWER,
	POST_EAST_TOWER,
	POST_LACRIMA,
	POST_NORTH_TOWER
}

@export var state_flags: Dictionary [StringName, PackedStringArray] = {
	'BEGIN': [],
	'POST_KINTA': ['demon_bros_fought'],
	'POST_WEST_TOWER': ['false_flag'],
	'POST_SOUTH_TOWER': ['false_flag'],
	'POST_EAST_TOWER': ['false_flag'],
	'POST_LACRIMA': ['false_flag'],
	'POST_NORTH_TOWER': ['false_flag']
}

func set_scene_state():
	for i in state_flags:
		if Checks.check_flags(state_flags[i]):
			Checks.state = STATE[i]
