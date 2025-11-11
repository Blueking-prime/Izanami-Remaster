extends Node

class_name MainMenu

@export var load_button: Button
@export var new_button: Button

@export var menu_ui: Control
@export var exit_button: Button
@export var settings_menu: OverlayMenu
@export var save_menu: SaveMenu
@export var save_icon: Control
@export var canvas_layer: CanvasLayer
@export var intro_scene: IntroScene

func _ready() -> void:
	SaveAndLoad.get_save_files()
	SaveAndLoad.load_settings()

	Global.exit_button = exit_button
	if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
	if not Global.exit_button.pressed.is_connected(Global._on_shop_exit): Global.exit_button.pressed.connect(Global._on_shop_exit)

	new_button.grab_focus()
	if not SaveAndLoad.save_files.is_empty():
		load_button.disabled = false
		load_button.grab_focus()

	#if get_tree().current_scene != self: get_tree().current_scene = self

func _on_load_pressed() -> void:
	SaveAndLoad.save_state = false
	save_menu.load_menu()
	menu_ui.hide()
	save_menu.show()

func _on_new_pressed() -> void:
	## Go to new game scene
	menu_ui.hide()
	if not SaveAndLoad.save_files.is_empty():
		var confirm = await Global.show_confirmation_box('Start New Game?')
		if confirm:
			intro_scene.play_intro()
		else:
			menu_ui.show()

func _on_settings_pressed() -> void:
	settings_menu.load_menu()
	menu_ui.hide()
	settings_menu.show()

func _on_exit_button_pressed():
	if menu_ui.visible:
		_on_quit_pressed()
	else :
		menu_ui.show()
		load_button.grab_focus()


func _on_quit_pressed() -> void:
	var confirm = await Global.show_confirmation_box('Exit game?')
	if confirm: get_tree().call_deferred("quit")
