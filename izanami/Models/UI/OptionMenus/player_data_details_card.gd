extends PanelContainer

class_name PlayerDetailsCard

@export var namefield: TextEdit
@export var classname: Label

@export var hpbar: ProgressBar
@export var hpbar_text: Label
@export var spbar: ProgressBar
@export var spbar_text: Label

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
