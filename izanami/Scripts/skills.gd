extends Node

class_name CharacterSkills

#@export_dir var skill_location: String
@export var _all_skills: Array[Skill] = []
@export var _skills: Array[Skill] = []
@export var skill_group: ResourceGroup

# Called when the node enters the scene tree for the first time.
func load_stock() -> void:
	if skill_group:
		skill_group.load_all_into(_all_skills)
		update_skills()

func add_skill(skill: Skill) -> void:
	#var skill = load(skill_location + '/' + skill_name + '.tres') as Skill
	if skill not in _skills:
		_skills.append(skill)

func remove_skill(skill: Skill) -> void:
	if skill in _skills:
		_skills.erase(skill)


func update_skills() -> void:
	for skill in _all_skills:
		if skill.lvl_requirement <= get_parent().lvl:
			add_skill(skill)


func get_skills() -> Array:
	return _skills
