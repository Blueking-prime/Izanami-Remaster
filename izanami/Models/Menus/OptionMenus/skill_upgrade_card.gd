extends Node

class_name SkillUpgradeCard

## CHILD NODES
@export var options: Options
@export var nametag: Label

## EXTERNAL PARAMETERS
@export var player: Player
@export var desc_box_container: BoxContainer
@export var confirm_button: Button

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	# Figure out how to display desc box for upgraded skill
	load_stock()

func load_stock():
	if player:
		nametag.text = player.nametag.text
		update_listing()

func update_listing():
	options.clear()

	if player.skills:
		for i in player.skills.get_skills():
			if i.rank < 2:
				options.add_item(
					i.name,
					rank_indicator(i.rank),
				)

func rank_indicator(rank: int) -> String:
	return '⬤'.repeat(rank) + '◯'.repeat(2 - rank)

func _on_item_selected(index: int) -> void:
	var skill: Skill = player.skills.get_skills()[index]
	get_parent().skill_id = index
	get_parent().current_player = player
	if skill:
		Global.show_description(skill)

	confirm_button.show()
