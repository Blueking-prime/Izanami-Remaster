extends StaticBody2D

@export var test_scene: PackedScene

var quest = GlobalQuests.Quest.new('Test Quest', [
	GlobalQuests.Quest.Objective.new('Go to Apothecary', ['apothecary_visit']),
	GlobalQuests.Quest.Objective.new('Buy at Smithy', ['smithy_buy']),
	GlobalQuests.Quest.Objective.new('Return to Test site', ['test_return']),
])
var quest_2 = GlobalQuests.Quest.new('Test 2 Quest', [
	GlobalQuests.Quest.Objective.new('Walk round map', ['meander']),
])

func main():
	if quest in Checks.active_quest_list:
		if quest_2 not in Checks.active_quest_list:
			Global.add_quest(quest_2)
		Checks.set_flags({'test_return': true})
	else :
		Global.add_quest(quest)

	get_parent().overlay.load_ui_elements()
	get_parent().overlay.show()
