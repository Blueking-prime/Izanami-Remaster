extends ScrollContainer

class_name CreditsRoll

@export var scroll_speed: int = 1
@export var pause: bool = false

func _process(delta: float) -> void:
	if not pause:
		scroll_vertical += ceili(scroll_speed * delta)
