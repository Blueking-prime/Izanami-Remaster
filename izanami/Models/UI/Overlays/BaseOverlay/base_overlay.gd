extends Control

class_name UIOverlay

@export var input_processing: UIOverlayInputProcessor

@export var map_cam: Map
@export var free_cam: FreeCam

@export_category('UI Elemnts')
@export var player_status: PlayerDataDisplay
@export var quest_display: QuestsDisplay
@export var music_display: MusicDisplay
@export var mag_counter: Label
@export var coin_counter: Label
@export var quick_info: QuickInfoPanel
@export var save_icon: Control

@export_category("Overlays")
@export var save_menu: SaveMenu
@export var settings_menu: OverlayMenu
@export var inventory_menu: InventoryMenu
@export var quests_menu: QuestMenu
@export var status_menu: StatusOverlay

var curr_menu: Control
var menu_list: Array
var save_enabled: bool = true


func _get_key_event_keycode(action_name: String) -> String:
	match Checks.retreive_setting('input_type'):
		0:
			return OS.get_keycode_string(
				InputMap.action_get_events(action_name)[0].get_keycode_with_modifiers()
			)
		#1: return Input.get_joy_button_string(
				#InputMap.action_get_events(action_name)[1].button_index
			#)
		_:
			return ''


func _assign_button_labels():
	for i in input_processing.button_container.get_children():
		var button_name: String = i.name.trim_suffix('Button')
		var event_key: String = _get_key_event_keycode(button_name.to_lower() + '_key')
		i.text = button_name
		if event_key != '':
			i.text += ' (' + event_key + ')'


func update_coin_counter():
	coin_counter.text = str(Global.players.gold)


func load_ui_elements():
	_assign_button_labels()
	menu_list = [inventory_menu, settings_menu, status_menu, quests_menu, save_menu]
	player_status.display_player_data()
	update_coin_counter()
	mag_counter.text = str(Global.players.mag)

	settings_menu.load_menu()
	quests_menu.load_menu()

	quest_display.connect_signals()
	quest_display.update_quest()

	music_display.connect_signals()
	music_display.update_track()


func _on_visibility_changed() -> void:
	if visible:
		input_processing.set_process_input(visible)
