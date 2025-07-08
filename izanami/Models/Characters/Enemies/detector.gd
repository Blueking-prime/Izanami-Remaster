extends Area2D

class_name EnemyDetector

func _on_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		get_parent().player = body
		get_parent().chase_player = true

func _on_body_shape_exited(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if body is Player:
		get_parent().chase_player = false
		get_parent().player = null
