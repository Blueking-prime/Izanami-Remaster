extends HBoxContainer

class_name PlayerDataCard

@export var player: Player
@export var sprite: TextureRect
@export var nametag: Label
@export var hp_bar: ProgressBar
@export var hp_bar_text: Label
@export var sp_bar: ProgressBar
@export var sp_bar_text: Label
@export var status_icons: GridContainer

func _update_hp_bar(value: int, text: String):
	hp_bar.value = value
	hp_bar_text.text = text

func _update_sp_bar(value: int, text: String):
	sp_bar.value = value
	sp_bar_text.text = text
