extends Status

class_name StatusBuff

@export var magnitude: float = 1

func _init() -> void:
	desc += str(magnitude * 100)
