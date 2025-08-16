extends StaticBody2D

@export var test_scene: PackedScene

var quest = GlobalQuests.Quest.new('Test Quest', [
	GlobalQuests.Quest.Objective.new('Go to Apothecary', 'apothecary_visit'),
	GlobalQuests.Quest.Objective.new('Buy at Smithy', 'smithy_buy'),
	GlobalQuests.Quest.Objective.new('Return to Test site', 'test_return'),
])
var quest_2 = GlobalQuests.Quest.new('Test 2 Quest', [
	GlobalQuests.Quest.Objective.new('Walk round map', 'meander'),
])

func main():

	#remove_child(test_player)
	#print(Global.players.gold)
	if quest in Global.active_quest_list:
		if quest_2 not in Global.active_quest_list:
			Global.add_quest(quest_2)
		Checks.test_return = true
		#print('Flag set')
	else :
		Global.add_quest(quest)

	#print(Checks.current_quest.title, Checks.current_quest)

	#print('Reload')
	get_parent().overlay.load_ui_elements()
	get_parent().overlay.show()
