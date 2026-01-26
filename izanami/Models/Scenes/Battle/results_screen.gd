extends Control

class_name ResultsScreen

@export var result: Label
@export var xp_result_label: Label
@export var g_result_label: Label

@export var animation_player: AnimationPlayer

signal exited

func _ready() -> void:
	set_process_unhandled_key_input(false)

func set_banner(won: bool):
	if won:
		result.text = 'Victory'
	else :
		result.text = 'Defeat'

func show_xp(value: int):
	xp_result_label.text = str(value) + " XP EARNED"

func show_g(value: int):
	g_result_label.text = str(value) + " G EARNED"


func _unhandled_key_input(_event: InputEvent) -> void:
	set_process_unhandled_key_input(false)
	LoadingScreen.show()
	await LoadingScreen.animation_player.animation_finished
	exited.emit()

func _on_visibility_changed() -> void:
	if visible:
		animation_player.play('show_screen')
		await animation_player.animation_finished
		set_process_unhandled_key_input(true)
		animation_player.play('press_any_key_loop')
	else :
		animation_player.stop()
		set_process_unhandled_key_input(false)
