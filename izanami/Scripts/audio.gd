extends Node

@export_category('Audio Players')
@export var BGM: AudioBGM
@export var SFX: AudioSFX

var current_scene: Node
var current_track: StringName:
	get(): return BGM.current_track

signal track_changed

#region BGM
func set_background_music(): return BGM.set_background_music()
func quiet(state: bool): return BGM.quiet(state)
func pause(): return BGM.pause()
func resume(): return BGM.resume()
func set_bg_audio_track(track: StringName): return BGM.set_bg_audio_track(track)
func get_current_audio_track_name() -> String: return BGM.get_current_audio_track_name()
func get_current_sudio_track_stream() -> AudioStream: return BGM.get_current_sudio_track_stream()
#endregion

#region SFX
func play_show_menu_sfx(state: bool): return SFX.play_show_menu_sfx(state)
func play_switch_menu_sfx(): return SFX.play_switch_menu_sfx()
func play_exit_menu_sfx(): return SFX.play_exit_menu_sfx()
func play_purchase_sfx(buy: bool): return SFX.play_purchase_sfx(buy)
func play_select_option_sfx(): return SFX.play_select_option_sfx()
func play_activate_option_sfx(): return SFX.play_activate_option_sfx()
func play_confirm_sfx(response: bool): return SFX.play_confirm_sfx(response)
func play_warp_sfx(): return SFX.play_warp_sfx()
#endregion
