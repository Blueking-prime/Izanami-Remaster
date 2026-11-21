extends Status

class_name StatusBuff

@export var magnitude: float = 1:
	set(value):
		magnitude = value
		desc = name + str(magnitude * 100) + '%'
