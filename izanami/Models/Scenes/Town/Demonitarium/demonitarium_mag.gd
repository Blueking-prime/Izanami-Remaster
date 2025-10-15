extends Node

@export var quantity_input: SpinBox
@export var confirm_button: Button

func buy_mag():
	Global.show_text_box("Crowley", "Whatever you want, I got it.", true)

	quantity_input.show()
	quantity_input.grab_focus()

	confirm_button.show()

	await confirm_button.pressed
	var x = quantity_input.value

	var cost = 10 * x
	var confirm = await Global.show_text_choice("Crowley", "That will be %d yen. | Balance: %d" % [cost, Global.player_party.gold])
	if confirm == 0:
		if Global.player_party.gold >= cost:
			Global.player_party.gold -= cost
			print(Global.player_party.gold)
			Global.player_party.mag += x
		else:
			await Global.show_text_box('System', "You don't have enough Yen")

	quantity_input.hide()
	confirm_button.hide()

	await get_parent().choose_option()
