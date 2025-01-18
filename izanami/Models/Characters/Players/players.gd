extends Node2D

class_name Party

var party: Array = []
var leader: Player
var index: int = 0

var party_panels: Dictionary = {}
var stored_pos: Vector2

@export var action_menu: Control
@export var skill_panel: Control
@export var source: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	party = get_children()
	leader = party[0]


## BATTLE SCENE
func battle_setup():
	stored_pos = leader.position
	z_index += 1

	for i in party:
		i.show()
		i.battle_display()

	freeze()

	place_menu()
	place_characters_in_battle()

func battle_reset():
	leader.position = stored_pos
	z_index -= 1

	for i in party:
		i.dungeon_display()
		i.hide()

	unfreeze()

	revert_menu()

	leader.show()


func place_characters_in_battle():
	var screen_size = get_viewport_rect().size
	screen_size.x /= 2
	screen_size.y /= 2

	#print(screen_size)
	var party_size = party.size()
	var x_coord
	var y_coord
	var hor_offset = screen_size.x * 0.2 #(1 / enemies_size)
	#for i in party_size:
		#x_coord = round(screen_size.x * .1 * 1) # Replace 1 with party[i].ally
		#if x_coord < 0:
			#x_coord = screen_size.x + x_coord
		#y_coord = round((screen_size.y / party_size) * i + screen_size.y * 0.1)
		#
		#party[i].position = Vector2(x_coord, y_coord)
		#print(party[i].name, party[i].position)
	#
	for i in party_size:
		y_coord = round(screen_size.y * .5 )
		x_coord = round(((screen_size.x / party_size) * i) + hor_offset) * party[i].ally
		if x_coord < 0:
			x_coord = screen_size.x + x_coord

		party[i].position = Vector2(x_coord, y_coord)
		#print(party[i].name, party[i].position)

func place_menu():
	for i in party:
		#i.item_menu.size = action_menu.size + Vector2(100, 0)
		#i.item_menu.position = action_menu.position + Vector2(140, 0)
		#i.skill_menu.size = action_menu.size + Vector2(100, 0)
		#i.skill_menu.position = action_menu.position + Vector2(140, 0)
		party_panels.get_or_add(i, [i.item_menu, i.skill_menu])
		i.item_menu = skill_panel
		i.skill_menu = skill_panel

func revert_menu():
	for i in party:
		i.item_menu = party_panels[i][0]
		i.skill_menu = party_panels[i][1]

func place_ui():
	pass

func level_up(xp: int):
	xp /= len(party)
	for i in party:
		i.level_up(xp)

func freeze():
	for i in party:
		i.freeze_movement = true

func unfreeze():
	for i in party:
		i.freeze_movement = false
