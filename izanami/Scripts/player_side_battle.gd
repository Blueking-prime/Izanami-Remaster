extends Node2D

var players: Array = []
var index: int = 0
@onready var action_menu: VBoxContainer = $"../CanvasLayer/Actions"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	players = get_children()
	place_menu()
	place_characters()

func place_characters():
	#Spawn players here
	var screen_size = get_viewport_rect().size
	screen_size.x /= 2
	screen_size.y /= 2

	print(screen_size)
	var players_size = players.size()
	var x_coord
	var y_coord
	var hor_offset = screen_size.x * 0.2 #(1 / enemies_size)
	#for i in players_size:
		#x_coord = round(screen_size.x * .1 * 1) # Replace 1 with players[i].ally
		#if x_coord < 0:
			#x_coord = screen_size.x + x_coord
		#y_coord = round((screen_size.y / players_size) * i + screen_size.y * 0.1)
		#
		#players[i].position = Vector2(x_coord, y_coord)
		#print(players[i].name, players[i].position)
	#
	for i in players_size:
		y_coord = round(screen_size.y * .5 )
		x_coord = round(((screen_size.x / players_size) * i) + hor_offset) * players[i].ally
		if x_coord < 0:
			x_coord = screen_size.x + x_coord
		
		players[i].position = Vector2(x_coord, y_coord)
		print(players[i].name, players[i].position)
	

func place_menu():
	for i in players:
		i.item_menu.size = action_menu.size + Vector2(100, 0)
		i.item_menu.position = action_menu.position + Vector2(140, 0)
		i.skill_menu.size = action_menu.size + Vector2(100, 0)
		i.skill_menu.position = action_menu.position + Vector2(140, 0)
