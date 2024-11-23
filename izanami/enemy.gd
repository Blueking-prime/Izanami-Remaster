class_name Enemy

extends Base_Character

func  _ready() -> void:
	ally = -1
	super._ready()

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
