extends Node

class_name SettingsFlags

#region TEXT SETTINGS
@export var scroll: bool = true
@export var scroll_speed: float = 0.05
@export var ffwd_speed: float = 0.3
@export var wait_time: float = 1
@export var input_type: int = 0
@export var thought_text_colour: Color
@export var small_text_size: int = 3
#endregion

#region Audio Settings
@export var Master_volume: float:
	set(arg): AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), arg)
	get(): return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
@export var BGM_volume: float:
	set(arg): AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("BGM"), arg)
	get(): return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("BGM"))
@export var SFX_volume: float:
	set(arg): AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), arg)
	get(): return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX"))
#endregion

#region Graphics Settings
@export var window_mode: int:
	set(arg): DisplayServer.window_set_mode(arg)
	get(): return DisplayServer.window_get_mode()
#endregion
