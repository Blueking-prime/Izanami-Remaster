extends Area2D

class_name EnemyDetector

const PLAYER_COLLISION_LAYER: int = 4

func _on_body_entered(body: Node2D) -> void:
	if body.get_collision_layer_value(PLAYER_COLLISION_LAYER):
		get_parent().player = body
		get_parent().chase_player = true


func _on_body_exited(body: Node2D) -> void:
	if body.get_collision_layer_value(PLAYER_COLLISION_LAYER):
		get_parent().chase_player = false
		get_parent().player = null
