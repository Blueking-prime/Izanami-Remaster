extends StaticBody2D

@export var test_scene: PackedScene

func main():
	var quest = Global.Quest.new('Test Quest', [
		Global.Quest.Objective.new('Go to Apothecary', 'apothecary_visit'),
		Global.Quest.Objective.new('Buy at Smithy', 'smithy_buy'),
		Global.Quest.Objective.new('Return to Test site', 'test_return'),
	])
	#remove_child(test_player)
	#print(Global.players.gold)
	if Checks.current_quest and Checks.current_quest.title == quest.title:
		Checks.test_return = true
		print('Flag set')
	else :
		Checks.current_quest = quest

	print(Checks.current_quest.title, Checks.current_quest)

	print('Reload')
	get_parent().overlay.load_ui_elements()
	get_parent().overlay.show()
