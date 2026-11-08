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

#region skill flags
var hemostasis: bool = false
var rankyaku_used: bool = false
var kami_e_used: bool = false
var tekkai_used: bool = false
var shigan_used: bool = false
var geppo_used: bool = false
#endregion
