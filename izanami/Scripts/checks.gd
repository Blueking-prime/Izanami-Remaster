extends Node

#// SETTINGS FLAGS //#
# Text settings
@export var scroll: bool = true
@export var scroll_speed: float = 0.05
@export var ffwd_speed: float = 0.3
@export var wait_time: float = 1


var refresh_shops: bool = false

## Menu persistance
var inventory_tab: int = 0
var battle_option: int = 0
var skill_option: int = 0
var item_option: int = 0
