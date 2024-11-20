extends "res://base_character.gd"

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
