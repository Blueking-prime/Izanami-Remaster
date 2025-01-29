extends Node2D

@onready var players: Party = get_parent().players

var cost: int = 0
var text_: String


func main():
	players.freeze()

	process_status()

	if cost > 0:
		await display_status()

	await dialogue()
	await choose()

	players.unfreeze()

func process_status():
	cost = 0
	text_ = ''
	for i in players.party:
		if i.hp < i.max_hp:
			cost += i.lvl * 5
			text_ += '%s -> HP : %d/%d | Status Effect : %s\n' % [i.name, i.hp, i.max_hp, i.status_effect]

func display_status():
	# Replace with dedicated UI
	await Global.show_text_box('', text_)

func dialogue():
	await Global.show_text_box('', "The soft scent of incense attacks you. There's a quiet hymn everberating from unknown places.")
	await Global.show_text_box("Sister Amaka", "Come my child, be healed")

func choose():
	var option = await Global.show_text_choice("", 'Choose: ', ['Healing', 'Purge', 'Blessing'])
	if option == 2:
		cost = len(players.party) * 20

	var heal = await Global.show_text_choice("Sister Amaka", "That will be %d yen | Balance: %d" % [cost, players.gold])
	if heal == 0:
		if players.gold >= cost:
			match option:
				0:
					for i in players.party: i.heal(i.max_hp)
					await Global.show_text_box("Sister Amaka","You have been healed. Go now and sin no more")
				1:
					for i in players.party: i.status_effect = 'null'
					await Global.show_text_box("Sister Amaka","You have been delivered from ailment. Go now and be free.")
				2:
					# Do something
					await Global.show_text_box("Sister Amaka","Our lord has granted you a boon")
			players.gold -= cost
		else:
			await Global.show_text_box('System', "You don't have enough Yen")
	print(players.gold)
