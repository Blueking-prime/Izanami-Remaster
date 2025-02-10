extends Node

class_name InventorySkillCard

## CHILD NODES
@export var list: ItemList
@export var count: ItemList
@export var nametag: Label

## EXTERNAL PARAMETERS
@export var players: Party
@export var player: Player
@export var desc_box_container: BoxContainer
@export var target_selector: TargetSelector

## WORKING VARIABLES
var selected_skill_index: int

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	players = Global.player_party
	if player:
		nametag.text = player.nametag.text
		update_listing()
	if target_selector:
		target_selector.item_activated.connect(choose_target)

func update_listing():
	list.clear()
	count.clear()

	if player.skills:
		for i in player.skills.get_skills():
			list.add_item(i.name)
			count.add_item(str(i.cost))

func show_target_selector():
	target_selector.clear()
	for i in players.party:
		target_selector.add_item(i)

	target_selector.show()
	target_selector.grab_focus()

func choose_target(index: int):
	player.use_skill(selected_skill_index, players.party[index])
	target_selector.hide()


func _on_item_activated(index: int) -> void:
	selected_skill_index = index
	var skill: Skill = player.skills.get_skills()[index]
	if skill.aoe:
		player.use_skill(index, players.party)
	elif not skill.targetable:
		player.use_skill(index, player)
	else:
		show_target_selector()
	_on_item_selected(index)

func _on_item_selected(index: int) -> void:
	list.select(index)
	count.select(index)
	var skill: Skill = player.skills.get_skills()[index]
	if skill:
		Global.show_description(skill)
