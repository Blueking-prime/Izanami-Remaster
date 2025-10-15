extends Node

class_name DemonitariumUpgrades

@export var upgrade_menu: SKillUpgradeMenu

func upgrade_skills():
	Global.sell.disconnect(get_parent()._sell_parser)

	upgrade_menu.load_menu()
	upgrade_menu.show()
	Global.show_text_box("Crowley", 'What skills would you like to upgrade?', true)

func choose_option():
	Global.sell.connect(get_parent()._sell_parser)
	Global.exit_button.show()
	await get_parent().choose_option()
