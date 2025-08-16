extends Control

class_name SKillUpgradeMenu

@export var shop_handler: Node
@export var skills_menu: InventorySkillMenu
@export var desc_box_container: BoxContainer

func load_menu():
	skills_menu.load_stock()

func _on_exit_button_pressed() -> void:
	if is_instance_valid(Global.description_box) and Global.description_box: Global.description_box.hide()
	hide()
	await shop_handler.choose_option()

func _on_visibility_changed() -> void:
	#Music.quiet(visible)
	if visible:
		Global.players.freeze()
		if not Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.connect(_on_exit_button_pressed)
		Global.exit_button.show()
		Global.description_box_parent = desc_box_container
		print(Global.description_box_parent)
	else :
		if Global.exit_signal.is_connected(_on_exit_button_pressed): Global.exit_signal.disconnect(_on_exit_button_pressed)
		if is_instance_valid(Global.exit_button): Global.exit_button.hide()
