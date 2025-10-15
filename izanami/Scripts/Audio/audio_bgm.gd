extends AudioStreamPlayer

class_name AudioBGM

enum TRACK {
	TOWN, DEMONITARIUM, DUNGEON, BATTLE, MAIN
}

var current_track: StringName

func set_background_music():
	if get_parent().current_scene == get_tree().current_scene: return

	get_parent().current_scene = get_tree().current_scene

	if get_parent().current_scene is Town:
		set_bg_audio_track('town_bgm')
	elif get_parent().current_scene is Demonitarium:
		set_bg_audio_track('demonitarium_bgm')
	elif get_parent().current_scene is Dungeon:
		set_bg_audio_track('dungeon_bgm')
	elif get_parent().current_scene is Battle:
		set_bg_audio_track('battle_bgm')
	elif get_parent().current_scene is MainMenu:
		set_bg_audio_track('main_menu_bgm')


	#print('Playing: ', stream)
	#print('Current Scene: ', current_scene)

func quiet(state: bool):
	if state:
		volume_db -= 10
	else :
		volume_linear = Checks.settings_flags.BGM_volume

func pause(): stream_paused = true

func resume(): stream_paused = false

func set_bg_audio_track(track: StringName):
	if track == current_track: return

	get_stream_playback().switch_to_clip_by_name(track)
	current_track = track

	if not playing:
		play()

	get_parent().track_changed.emit()

func get_current_audio_track_name() -> String:
	return get_current_sudio_track_stream().resource_path.get_file().get_basename().to_snake_case().capitalize()

func get_current_sudio_track_stream() -> AudioStream:
	return stream.get_clip_stream(_get_track_index(current_track))

func _get_track_index(track: StringName) -> int:
	match track:
		'town_bgm': return TRACK.TOWN
		'demonitarium_bgm': return TRACK.DEMONITARIUM
		'dungeon_bgm': return TRACK.DUNGEON
		'battle_bgm': return TRACK.BATTLE
		'main_menu_bgm': return TRACK.MAIN

		_: return TRACK.MAIN
