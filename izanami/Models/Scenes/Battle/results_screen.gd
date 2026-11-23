extends Control

class_name ResultsScreen

@export var result: Label
@export var xp_result_label: Label
@export var g_result_label: Label
@export var lvl_up_display: HBoxContainer

@export var results_screen_card_scene: PackedScene

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

func spawn_results(p_name: String, lvls: Array[int], stats: Array[Dictionary]):
	var card: ResultsScreenCard = results_screen_card_scene.instantiate()

	card.set_change_info(p_name, lvls, stats)

	lvl_up_display.add_child(card)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and visible:
		Global.next.emit()

func _on_screen_gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("click") and visible:
		Global.next.emit()


func _on_visibility_changed() -> void:
	if visible:
		animation_player.play('show_screen')
		await animation_player.animation_finished
		animation_player.play('press_any_key_loop')
		await Global.next
		LoadingScreen.show()
		await LoadingScreen.animation_player.animation_finished
		exited.emit()
	else :
		animation_player.stop()
		set_process_unhandled_key_input(false)
