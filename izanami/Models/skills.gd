extends Node

@export_file('*.tres') var character_skills: Array[String] = []
@export var _skills: Array[Skill] = []
@export_dir var skill_location: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for file in DirAccess.get_files_at(skill_location):
		if skill_location + '/' + file in character_skills:
			var skill_file = skill_location + '/' + file
			var skill: Skill = load(skill_file) as Skill
			add_skill(skill)


func add_skill(skill: Skill):
	var _skill_names = []
	for i in _skills:
		_skill_names.append(i.name)
	
	if skill.name not in _skill_names:
		_skills.append(skill)


func get_skills():
	return _skills
