extends Node

class_name DemonitariumUpgrades

@export var upgrade_menu: Control
@export var upgrade_panel: VBoxContainer

func upgrade_skills():
	upgrade_menu.show()
	upgrade_panel.load_stock()
	upgrade_panel.grab_focus()
	Global.show_text_box("Crowley", 'What skills would you like to upgrade?', true)
