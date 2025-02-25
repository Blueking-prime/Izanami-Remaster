extends Resource

class_name Status

@export var duration: int = 1
@export var elapsed: int

func trigger(_victim: Base_Character):
	elapsed += 1
	print("yay")
