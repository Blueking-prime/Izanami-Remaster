extends PanelContainer

class_name MusicDisplay

@export var text_label: Label

func connect_signals():
	if not Audio.track_changed.is_connected(_on_track_changed):
		Audio.track_changed.connect(_on_track_changed)

func update_track():
	#print(Audio.BGM.stream)
	#print(Audio.BGM.playing)
	if Audio.BGM.stream and Audio.BGM.playing:
		text_label.text = Audio.get_current_audio_track_name()
	else :
		text_label.text = 'No Track Playing'

func _on_track_changed() -> void:
	#await get_tree().create_timer(0.5).timeout
	update_track()
