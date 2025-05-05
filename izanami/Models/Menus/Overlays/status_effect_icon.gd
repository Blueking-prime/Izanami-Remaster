extends TextureRect

class_name StatusEffectIcon

@export var counter: Label
@export var effect_name: Label

func _on_mouse_entered() -> void:
	effect_name.show()

func _on_mouse_exited() -> void:
	effect_name.hide()
