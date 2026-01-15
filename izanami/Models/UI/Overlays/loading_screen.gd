extends Node

@export var canvas_layer: CanvasLayer
@export var animation_player: AnimationPlayer

func show():
	if canvas_layer.visible: return

	canvas_layer.show()
	animation_player.play("fade_to_black")
	await animation_player.animation_finished

func hide():
	animation_player.play("fade_out")
	await animation_player.animation_finished
	canvas_layer.hide()
