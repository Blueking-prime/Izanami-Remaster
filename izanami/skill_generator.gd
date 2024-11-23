@tool
extends EditorScript

var all_skills = JSON.parse_string(FileAccess.open("res://temp_skills.json", FileAccess.READ).get_as_text())

func _run() -> void:
	# Create a new Texture resource instance
	for i in all_skills:
		var skill = Skill.new()
		skill.name = i.get('name')
		skill.stats = i.get('stats', [])
		skill.stat_multiplier = i.get('stat_multiplier', 1)
		skill.cost = i.get('cost', 0)
		skill.boost = i.get('boost', [1, 1])
		skill.flavour_text = i.get('flavour_text', '')
		skill.element = i.get('trait', '')
		skill.status_effect = i.get('status_effect', [])

		# Set additional properties as needed

		# Save the resource to disk
		var save_path = "res://skills/" + skill.name + ".tga"
		var save_result = ResourceSaver.save(skill, save_path)
		if save_result != OK:
			print("Error saving resource: ", save_result)
