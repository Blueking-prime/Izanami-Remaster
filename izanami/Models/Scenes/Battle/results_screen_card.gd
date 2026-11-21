extends PanelContainer

class_name ResultsScreenCard

@export var nametag: Label
@export var init_lvl: Label
@export var fin_lvl: Label

@export var stat_change_container: VBoxContainer

@export var stat_change_scene: PackedScene

func set_change_info(player_name: String, lvls: Array[int], stats: Array[Dictionary]):
	nametag.text = player_name
	init_lvl.text = str(lvls[0])
	fin_lvl.text = str(lvls[1])

	for i in stats[0]:
		var stat_change: StatChange = stat_change_scene.instantiate()
		stat_change.statname.text = i
		stat_change.init_stat.text = str(stats[0][i])
		if stats[1][i] > stats[0][i]:
			stat_change.arrow.show()
			stat_change.fin_stat.text = str(stats[1][i])
			stat_change.fin_stat.show()

		stat_change_container.add_child(stat_change)
