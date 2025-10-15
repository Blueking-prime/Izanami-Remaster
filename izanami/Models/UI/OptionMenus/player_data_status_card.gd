extends PanelContainer

class_name PlayerStatusCard

@export var nametag: Label
@export var classname: Label

@export var leader_icon: Control
@export var icon: TextureRect

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

@export var description: Label

@export var status_effect: Label

@export var select_button: Button

@export var extra_details_card: Control

@export var player: Player

signal selected(node: PlayerStatusCard)

func _on_button_pressed() -> void:
	selected.emit(self)
