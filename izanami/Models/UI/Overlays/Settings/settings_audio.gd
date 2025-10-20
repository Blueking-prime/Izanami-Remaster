extends HBoxContainer

@export_enum('Master', 'BGM', 'SFX') var bus_name: String

@export var slider: HSlider
@export var input_field: LineEdit

func _ready() -> void:
	var value = Checks.retreive_setting(bus_name + '_volume')
	slider.set_value_no_signal(value)
	input_field.text = str(int(value * 100))

func _on_slider_value_changed(value: float) -> void:
	input_field.text = str(int(value * 100))
	Checks.change_setting(bus_name + '_volume', value)

func _on_input_text_submitted(new_text: String) -> void:
	if new_text.is_valid_int():
		var value := clampf(new_text.to_float() / 100, slider.min_value, slider.max_value)
		slider.value = value

	input_field.text = str(int(slider.value * 100))
