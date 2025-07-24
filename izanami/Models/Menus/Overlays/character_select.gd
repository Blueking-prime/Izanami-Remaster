extends Panel

class_name CharacterSelector

@export var player_status_card_scene: PackedScene
@export var player_details_card_scene: PackedScene
@export var available_class_scenes: Array[PackedScene]
@export var player_party_scene: PackedScene

@export var player_container: HBoxContainer
@export var player_node_container: Node
@export var back_button: Button

@export var available_classes: Array[Player]

@export var player_party: Party

func _ready() -> void:
	if not Global.player_party:
		Global.player_party = player_party_scene.instantiate()

	player_party = Global.player_party
	load_menu()

func load_menu():
	_clear_data_cards()
	load_classes()
	for i in available_classes:
		player_node_container.add_child(i)
		create_card(i)
		i.hide()

func load_classes():
	available_classes = []
	for i in available_class_scenes:
		available_classes.append(i.instantiate())

func create_card(player: Player):
	var card: PlayerStatusCard = player_status_card_scene.instantiate()
	var details: PlayerDetailsCard = player_details_card_scene.instantiate()

	card.nametag.hide()
	card.classname.text = player.classname
	card.classname.size_flags_horizontal = Control.SIZE_SHRINK_CENTER | Control.SIZE_EXPAND
	details.classname. text = player.classname

	card.icon.texture = player.battle_sprite_texture.texture

	card.hpbar.hide()
	card.spbar.hide()

	details.hpbar.value = player.hp_bar.value
	details.hpbar_text.text = player.hp_bar_text.text
	details.spbar.value = player.sp_bar.value
	details.spbar_text.text = player.sp_bar_text.text

	details.stats_str.text = str(player.stats.STR)
	details.stats_int.text = str(player.stats.INT)
	details.stats_wis.text = str(player.stats.WIS)
	details.stats_end.text = str(player.stats.END)
	details.stats_gui.text = str(player.stats.GUI)
	details.stats_agi.text = str(player.stats.AGI)

	card.description.text = player.desc

	#card.get_node('MarginContainer/VBoxContainer/BARS').hide()
	#card.get_node('MarginContainer/VBoxContainer/STATSECTION').hide()
	#card.get_node('MarginContainer/VBoxContainer/GEAR').hide()

	card.get_node('MarginContainer/VBoxContainer/StatsBox').hide()
	card.get_node('MarginContainer/VBoxContainer/GearBox').hide()
	card.get_node('MarginContainer/VBoxContainer/StatusBox').hide()
	card.select_button.show()

	card.extra_details_card = details
	details.hide()

	player_container.add_child(card)
	player_container.add_child(details)

	card.selected.connect(choose_target)
	details.selected.connect(confirm_choice)

func _clear_data_cards():
	var children = player_container.get_children()
	if children:
		for i in children:
			if is_instance_valid(i):
				if is_ancestor_of(i): remove_child(i)
				i.queue_free()


func choose_target(card: PlayerStatusCard):
	for i in player_container.get_children():
		if not i == card: i.hide()

	back_button.show()
	card.select_button.hide()
	card.extra_details_card.show()

func confirm_choice(card: PlayerDetailsCard):
	# Maybe remove other nodes instead and change this to party node
	var player: Player
	for i in player_node_container.get_children():
		if i.classname == card.classname.text:
			player = i

	player.character_name = card.namefield.text
	player_node_container.remove_child(player)
	player_party.add_to_party(player)
	player_party.load_party()
	Global.set_seed()
	print(player_party)
	print(player_party.get_children())
	hide()

func _on_button_pressed() -> void:
	back_button.hide()
	for i in player_container.get_children():
		i.hide()
		if i is PlayerStatusCard:
			i.show()
			i.select_button.show()
