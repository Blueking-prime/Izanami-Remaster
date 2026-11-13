extends Node

class_name Flags

#region Test Flags
var main_check: bool = true
var main_flag: bool = false
var hidden_flag: bool = false
var another_flag: bool = true
var alt_flag: bool = true
var apothecary_visit: bool = false
var smithy_buy: bool = false
var test_return: bool = false
var meander: bool = false
#endregion

const SKILL_FLAGS: Array = [
	'hemostasis',
	'rankyaku_used',
	'kami_e_used',
	'tekkai_used',
	'shigan_used',
	'geppo_used',
]

var true_flag: bool = true
var false_flag: bool = false

#region Skill Flags
var hemostasis: bool = false

var rankyaku_used: bool = false
var kami_e_used: bool = false
var tekkai_used: bool = false
var shigan_used: bool = false
var geppo_used: bool = false

var babel_chaos_death_count: int = 0
#endregion

#region Story Flags
var orbs_obtained: int = 0:
	get():
		return int(east_tower_orb) + int(babel_chaos_orb) + int(refael_orb) + int(caliburn_orb)

var caliburn_orb: bool = false
var refael_orb: bool = false
var east_tower_orb: bool = false
var babel_chaos_orb: bool = false

var beatrix_saved: bool = false:
	set(value):
		if fu_liang_saved:
			beatrix_saved = false
		else :
			beatrix_saved = value
var fu_liang_saved: bool = false:
	set(value):
		if beatrix_saved:
			fu_liang_saved = false
		else :
			fu_liang_saved = value

var demon_bros_fought: bool = false
var kinta_npcs_spoken_to: bool = false

var fight_refael: bool = false
var join_refael: bool = false

var yuan_dao_side: bool = false
var black_dragon_side: bool = false
var dragonlord_spoken_to: bool = false
var symbiote_stabilizer: bool = false

var insurgent_intel: bool = false
var open_secret_hideout: bool = false
var lacrima_obtained: bool = false
var babel_trigger: bool = false

var zhu_mei_saved: bool = false
var bio_material: bool = false

var asura_o_defeated: bool = false
var kijo_momiji: bool = false
var giles_cleanse_ending: bool = false
#endregion

var cave_one_trigger: bool = false
var cave_two_trigger: bool = false
var cave_three_trigger: bool = false

#region Party Member Flags
var zhu_mei_in_party: bool = false
var beatrix_in_party: bool = false
#endregion

#region Cutscene Flags
var played_cutscenes: Array = []
#endregion
