extends AudioStreamPlayer

class_name AudioSFX

@export var show_menu_sfx: AudioStream
@export var hide_menu_sfx: AudioStream
@export var switch_menu_sfx: AudioStream
@export var exit_menu_sfx: AudioStream
@export var show_selector_sfx: AudioStream

@export var buy_sfx: AudioStream
@export var sell_sfx: AudioStream

@export var select_option_sfx: AudioStream
@export var activate_option_sfx: AudioStream

@export var choose_confrim_sfx: AudioStream
@export var cancel_confrim_sfx: AudioStream

@export var warp_sfx: AudioStream


func _play_sfx(track: AudioStream):
	#var playback_stream: AudioStreamPlaybackPolyphonic = get_stream_playback()
	if playing:
		get_stream_playback().play_stream(track, 0, 0, randf_range(0.8, 1.2))


func play_show_menu_sfx(state: bool):
	if state:
		_play_sfx(show_menu_sfx)
	else:
		_play_sfx(hide_menu_sfx)

func play_switch_menu_sfx():
	_play_sfx(switch_menu_sfx)

func play_exit_menu_sfx():
	_play_sfx(exit_menu_sfx)

func play_purchase_sfx(buy: bool):
	if buy:
		_play_sfx(buy_sfx)
	else :
		_play_sfx(sell_sfx)


func play_select_option_sfx():
	_play_sfx(select_option_sfx)

func play_activate_option_sfx():
	_play_sfx(activate_option_sfx)

func play_confirm_sfx(response: bool):
	if response:
		_play_sfx(choose_confrim_sfx)
	else :
		_play_sfx(cancel_confrim_sfx)


func play_warp_sfx():
	_play_sfx(warp_sfx)
