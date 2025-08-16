extends InventorySkillCard

class_name SkillUpgradeCard

func update_listing():
	options.clear()

	if player.skills:
		for i in player.skills.get_skills():
			if i.rank < 2:
				options.add_item(
					i.name,
					[rank_indicator(i.rank),]
				)

func rank_indicator(rank: int) -> String:
	return '⬤'.repeat(rank) + '◯'.repeat(2 - rank)

func upgrade_skill(skill_id: int):
	var skill: Skill = player.skills.get_skills()[skill_id]
	if skill:
		# Deduct Currency
		skill.rank += 1

	load_stock()


func _on_item_activated(index: int) -> void:
	_on_item_selected(index)
	var skill: Skill = player.skills.get_skills()[index]
	var confirm = await Global.show_confirmation_box('Upgrade %s' % [skill.name])
	if confirm:
		upgrade_skill(index)
	_on_item_selected(index)
