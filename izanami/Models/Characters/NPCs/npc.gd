extends CharacterBody2D

class_name NPC

@export_file('*.json') var cutscene: String

@export var path_follow: PathFollow2D
@export var speed: float = 100
var frozen: bool = false


func _physics_process(delta: float) -> void:
	if not frozen: path_follow.progress += speed * delta
	if frozen and not Global.players.frozen: frozen = false

func dialogue():
	frozen = true
	Dialogue.show_cutscene(cutscene)

func trigger_interact_flags():
	pass
