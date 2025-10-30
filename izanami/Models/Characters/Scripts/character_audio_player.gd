extends Node2D

class_name CharacterAudio

@export_category('AudioStreams')
@export var walk_sfx: AudioStream
@export var attack_sfx: AudioStream
@export var support_sfx: AudioStream

@export var damage_sfx: AudioStream
@export var heal_sfx: AudioStream
@export var evade_sfx: AudioStream
@export var crit_sfx: AudioStream

@export var status_sfx: AudioStream

@export var die_sfx: AudioStream
@export var revive_sfx: AudioStream

@export_category('Handlers')
@export var local: AudioStreamPlayer2D
@export var global: AudioStreamPlayer

var walking_audio_stream_id: int

func _play_sfx(track: AudioStream):
	#var playback_stream: AudioStreamPlaybackPolyphonic = get_stream_playback()
	match get_parent().state:
		Base_Character.STATES.BATTLE:
			if global.playing: global.get_stream_playback().play_stream(track, 0, 0, randf_range(0.8, 1.2))
		Base_Character.STATES.IDLE, Base_Character.STATES.WALKING:
			if local.playing: local.get_stream_playback().play_stream(track, 0, 0, randf_range(0.8, 1.2))


func play_walking_sfx():
	if local.playing:
		if get_parent().state == Base_Character.STATES.WALKING: # and not local.get_stream_playback().is_stream_playing(walking_audio_stream_id):
			walking_audio_stream_id = local.get_stream_playback().play_stream(walk_sfx, 0, 0, randf_range(0.8, 1.2))
		elif get_parent().state != Base_Character.STATES.WALKING: # and local.get_stream_playback().is_stream_playing(walking_audio_stream_id):
			local.get_stream_playback().stop_stream(walking_audio_stream_id)


func play_attack_sfx(): _play_sfx(attack_sfx)
func play_support_sfx(): _play_sfx(support_sfx)
func play_damage_sfx(): _play_sfx(damage_sfx)
func play_heal_sfx(): _play_sfx(heal_sfx)
func play_crit_sfx(): _play_sfx(crit_sfx)
func play_evade_sfx(): _play_sfx(evade_sfx)
func play_status_sfx(): _play_sfx(status_sfx)
func play_die_sfx(): _play_sfx(die_sfx)
func play_revive_sfx(): _play_sfx(revive_sfx)


func _on_state_changed() -> void:
	if visible:
		play_walking_sfx()
