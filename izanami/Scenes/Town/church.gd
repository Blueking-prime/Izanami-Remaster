extends Node2D

class_name TownChurch

var cost: int = 0
var text_: String

@onready var back_button: Button = get_parent().back_button
@onready var overlay: UIOverlay = get_parent().overlay

func main():
	Global.players.freeze()

	back_button.show()
	back_button.pressed.connect(exit_shop)
	Global.sell.connect(_sell_parser)

	process_status()

	if cost > 0:
		await display_status()

	await dialogue()
	await choose()

	exit_shop()

func process_status():
	cost = 0
	text_ = ''
	for i in Global.players.party:
		if i.hp < i.max_hp and i is Player:
			cost += i.lvl * 5
			text_ += '%s -> HP : %d/%d | Status Effect : %s\n' % [i.name, i.hp, i.max_hp, str(i.statuses.status_effects)]

func display_status():
	# Replace with dedicated UI
	await Global.show_text_box('', text_)

func dialogue():
	await Global.show_text_box('', "The soft scent of incense attacks you. There's a quiet hymn everberating from unknown places.")
	await Global.show_text_box("Sister Amaka", "Come my child, be healed")

func choose():
	var option = await Global.show_text_choice("", 'Choose: ', ['Healing', 'Purge', 'Blessing'])
	if option == 2:
		cost = len(Global.players.party) * 20

	var heal = await Global.show_text_choice("Sister Amaka", "That will be %d yen | Balance: %d" % [cost, Global.players.gold])
	if heal == 0:
		if Global.players.gold >= cost:
			match option:
				0:
					for i in Global.players.party: i.heal(i.max_hp)
					await Global.show_text_box("Sister Amaka","You have been healed. Go now and sin no more")
				1:
					for i in Global.players.party: i.status_effect = 'null'
					await Global.show_text_box("Sister Amaka","You have been delivered from ailment. Go now and be free.")
				2:
					# Do something
					await Global.show_text_box("Sister Amaka","Our lord has granted you a boon")
			Global.players.gold -= cost
		else:
			await Global.show_text_box('System', "You don't have enough Yen")

func exit_shop():
	if Global.text_box:
		Global.text_box.queue_free()
	Global.sell.disconnect(_sell_parser)
	back_button.hide()
	overlay.show()
	Global.players.unfreeze()

func _sell_parser(arg: String):
	if arg == 'exit':
		exit_shop()
