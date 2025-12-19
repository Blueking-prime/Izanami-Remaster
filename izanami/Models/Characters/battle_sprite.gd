extends MarginContainer

class_name BattleSprite

@export var nametag: Label
@export var status_icons: GridContainer
@export var sprite: TextureRect
@export var pointer: TextureRect
@export var indicator: TextureRect
@export var hp_bar: ProgressBar
@export var hp_bar_text: Label
@export var sp_bar: ProgressBar
@export var sp_bar_text: Label
@export var animation_player: AnimationPlayer

func _update_hp_bar(value: int, text: String):
	hp_bar.value = value
	hp_bar_text.text = text

func _update_sp_bar(value: int, text: String):
	sp_bar.value = value
	sp_bar_text.text = text

func _set_pointer(_visible: bool):
	pointer.visible = _visible

func _set_indicator(_visible: bool):
	indicator.visible = _visible
