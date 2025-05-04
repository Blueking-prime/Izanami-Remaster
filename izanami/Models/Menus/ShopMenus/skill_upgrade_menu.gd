extends VBoxContainer

@export var skill_upgrade_card_scene: PackedScene

## EXTERNAL PARAMETERS
@export var players: Party
@export var desc_box_container: BoxContainer
@export var confrim_button: Button

var skill_id: int
var current_player: Player

func _ready() -> void:
	Global.description_box_parent = desc_box_container
	load_stock()

func load_stock():
	if Global.player_party:
		players = Global.player_party

	_clear_data_cards()
	if players:
		for i in players.party:
			create_card(i)

func create_card(player: Player):
	var card: SkillUpgradeCard = skill_upgrade_card_scene.instantiate()
	card.desc_box_container = desc_box_container
	card.player = player
	card.confirm_button = confrim_button
	card.load_stock()

	add_child(card)

func _clear_data_cards():
	var children = get_children()
	if children:
		for i in children:
			remove_child(i)
			i.queue_free()

func upgrade_skill():
	var skill: Skill = current_player.skills.get_skills()[skill_id]
	if skill:
		# Deduct Currency
		skill.rank += 1

	confrim_button.hide()
	load_stock()
