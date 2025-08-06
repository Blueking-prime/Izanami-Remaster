class_name Enemy

extends Base_Character

@export var nav_agent: NavigationAgent2D
@export var path_switch_timer: Timer
@export var detector: EnemyDetector

@export var atk_lines: Array = []
@export var speed: int
@export var freeze: bool = false

@export var heal_threshold: float = 0.8

@export var map_size: Vector2 = Vector2(1000, 1000)

var player: Player
var chase_player: bool = false
var target_position: Vector2

func  _ready() -> void:
	ally = -1
	super()
	_on_navigation_agent_2d_navigation_finished()

func _physics_process(delta: float) -> void:
	if freeze: return

	if not NavigationServer2D.map_get_iteration_id(nav_agent.get_navigation_map()): return

	if chase_player:
		if not Global.players.chased: Global.players.chased = true
		target_position = player.global_position

	nav_agent.target_position = target_position

	var direction = to_local(nav_agent.get_next_path_position()).normalized()
	#print(direction)

	var intended_velocity = direction * speed * delta * 1000
	#print("OG: ",intended_velocity.length())
	nav_agent.set_velocity(intended_velocity)
	#velocity = direction * speed * delta * 1000
	#print(velocity.length())
	#velocity = position.direction_to(player.global_position) * speed * delta * 1000

	#move_and_slide()

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
		await get_tree().create_timer(1).timeout


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
		await get_tree().create_timer(1).timeout

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


func _on_navigation_agent_2d_navigation_finished() -> void:
	target_position = Vector2(randi_range(0, map_size.x), randi_range(0, map_size.y))
	path_switch_timer.start()


func _on_path_switch_timer_timeout() -> void:
	target_position = Vector2(randi_range(0, map_size.x), randi_range(0, map_size.y))


func _on_navigation_agent_2d_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	#print("Safe: ",velocity.length())
	move_and_slide()
