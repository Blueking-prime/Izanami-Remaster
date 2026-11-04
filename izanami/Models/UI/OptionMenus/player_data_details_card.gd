extends PanelContainer

class_name PlayerDetailsCard

@export var namefield: TextEdit
@export var classname: Label

@export var hp_bar: ProgressBar
@export var hp_bar_text: Label
@export var sp_bar: ProgressBar
@export var sp_bar_text: Label


@export var stats: Dictionary
@export var stats_str: Label
@export var stats_int: Label
@export var stats_wis: Label
@export var stats_end: Label
@export var stats_gui: Label
@export var stats_agi: Label

@export var head: Label
@export var body: Label
@export var weapon: Label

@export var select_button: Button

signal selected(node: PlayerDetailsCard)

func _on_button_pressed() -> void:
	selected.emit(self)

func _update_hp_bar(value: int, text: String):
	hp_bar.value = value
	hp_bar_text.text = text

func _update_sp_bar(value: int, text: String):
	sp_bar.value = value
	sp_bar_text.text = text

func assign_stats_to_UI() -> void:
	stats_str.text = str(stats.STR)
	stats_int.text = str(stats.INT)
	stats_wis.text = str(stats.WIS)
	stats_end.text = str(stats.END)
	stats_gui.text = str(stats.GUI)
	stats_agi.text = str(stats.AGI)
