extends Area2D

class_name EnemyDetector

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		get_parent().player = body
		get_parent().chase_player = true


func _on_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Player:
		get_parent().chase_player = false
		get_parent().player = null
