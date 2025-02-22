class_name Enemy

extends Base_Character

@export var atk_lines: Array = []
@export var element: StringName
@export var speed: int

var player: Player
var chase_player: bool = false

func  _ready() -> void:
	ally = -1
	super()

func use_skill(skill_id, _target):
	print(atk_lines[randi_range(0, atk_lines.size() - 1)])
	super.use_skill(skill_id,_target)

func _physics_process(delta: float) -> void:
	if chase_player:
		if not Global.player_party.chased: Global.player_party.chased = true

		velocity = position.direction_to(player.global_position) * speed * delta * 1000
		move_and_slide()

func gold_drop():
	var sum = 0
	for i in stats:
		sum += stats[i]

	return sum * 10

func exp_drop():
	var sum = 0
	for i in stats:
		sum += stats[i]

	return sum * 9
