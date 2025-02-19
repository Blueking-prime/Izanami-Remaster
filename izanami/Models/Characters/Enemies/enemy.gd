class_name Enemy

extends Base_Character

@export var atk_lines: Array = []
@export var element: StringName

func  _ready() -> void:
	ally = -1
	super()

func use_skill(skill_id, _target):
	print(atk_lines[randi_range(0, atk_lines.size() - 1)])
	super.use_skill(skill_id,_target)


func gold_drop():
	var sum = 0
	for i in stats:
		sum += stats[i]

	return sum * 10

func exp_drop():
	var sum = 0
	for i in stats:
		sum += stats[i]

	return sum * 9
