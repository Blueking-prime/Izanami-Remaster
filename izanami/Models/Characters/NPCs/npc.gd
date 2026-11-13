extends CharacterBody2D

class_name NPC

@export var cutscenes: Dictionary [StateHandler.STATE, Resource] = {}

@export var path_follow: PathFollow2D
@export var speed: float = 100
var frozen: bool = false
var current_cutscene: JSON

func _physics_process(delta: float) -> void:
	if not path_follow: return
	if not frozen: path_follow.progress += speed * delta
	if frozen and not Global.players.frozen: frozen = false

func set_cutscene():
	#var state: int = Checks.state
	#while not cutscenes.has(state) and state > 0:
		#state -= 1
	if cutscenes.has(Checks.state):
		current_cutscene = cutscenes[Checks.state]
		if not Checks.check_cutscene_played(current_cutscene):
			return

	current_cutscene = cutscenes[StateHandler.STATE.DEFAULT]

func dialogue():
	frozen = true
	set_cutscene()
	await Dialogue.show_cutscene(current_cutscene)
	current_cutscene = cutscenes[StateHandler.STATE.DEFAULT]

func trigger_interact_flags():
	pass
