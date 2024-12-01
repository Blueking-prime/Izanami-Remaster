class_name Enemy

extends Base_Character

@export var atk_lines: Array = []
@export var element: StringName

func  _ready() -> void:
	ally = -1
	super()

func use_skill(skill_id, target):
	print(atk_lines[randi_range(0, atk_lines.size() - 1)])
	super.use_skill(skill_id,target)


func gold_drop():
	var sum = 0
	for i in stats:
		sum += i.value
	
	return sum * 10

func exp_drop():
	var sum = 0
	for i in stats:
		sum += i.value
	
	return sum * 9

func die():
	#hide()
	super.die()
