class_name Enemy

extends Base_Character

@export var atk_lines: Array = []
@export var speed: int

@export var heal_threshold: float = 0.8

var player: Player
var chase_player: bool = false

func  _ready() -> void:
	ally = -1
	super()

func _physics_process(delta: float) -> void:
	if chase_player:
		if not Global.player_party.chased: Global.player_party.chased = true

		velocity = position.direction_to(player.global_position) * speed * delta * 1000
		move_and_slide()

func use_skill(skill_id, _target):
	Global.print_to_log(atk_lines[randi_range(0, atk_lines.size() - 1)])
	super.use_skill(skill_id,_target)


func battle_ai(player_array: Array, enemy_array: Array):
	var skill_id = randi_range(0, get_skills().size() - 1)
	var skill: Skill = get_skills()[skill_id]

	var target_array = player_array
	if skill is Heal_Skill:
		target_array = enemy_array

	if skill.aoe:
		use_skill(skill_id, target_array)

	else:
		var target_actor = target_array[randi_range(0, target_array.size() - 1)]
		if skill is Heal_Skill:
			if hp < max_hp * heal_threshold:
				# heal self
				target_actor = self
			else:
				# heal lowest hp ally
				target_actor = target_array.reduce(func(a, b): return a if a.hp < b.hp else b)

		use_skill(skill_id, target_actor)
	Global.print_to_log('from ' + character_name)

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
