extends Node

#@export_dir var skill_location: String
@export var _all_skills: Array[Skill] = []
@export var _skills: Array[Skill] = []
@export var skill_group: ResourceGroup

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if skill_group:
		skill_group.load_all_into(_all_skills)
		update_skills()

func add_skill(skill: Skill):
	#var skill = load(skill_location + '/' + skill_name + '.tres') as Skill
	var _skill_names = []
	for i in _skills:
		_skill_names.append(i.name)

	if skill.name not in _skill_names:
		_skills.append(skill)

func update_skills():
	for skill in _all_skills:
		if skill.lvl_requirement <= get_parent().lvl:
			add_skill(skill)


func get_skills():
	return _skills
