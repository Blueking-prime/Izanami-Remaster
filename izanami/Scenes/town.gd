extends Node2D

class_name Town

@export var church: Node
@export var smithy: Node
@export var apothecary: Node
@export var dungeon: Node
@export var demonitarium: Node
@export var palace: Node

@export var crowley: Node
@export var kobaneko: Node
@export var white: Node

@export var players: Party

var locations = ["Palace", "Church", "Smithy", "Apothecary", "Demonitorium", "Dungeon"]
var actions = ['Talk', "Go Somewhere", 'Status']
var characters = ["Kobaneko", "White"]

func _ready() -> void:
	players.leader.detector.hit_building.connect(_check_building)
	Global.player_party = players


func _check_building(node: Variant):
	match node:
		church: church.main()
		dungeon: dungeon.main()
		smithy: smithy.main()
		apothecary: apothecary.main()
		demonitarium: demonitarium.main()
		palace: palace.main()

#func _input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_end"):
		#func_church()

#func main():
	#var action = await Global.show_text_choice("What do you want to do?", actions)
	#match action:
		#1:
			#talk()
		#2:
			#enter()
		#3:
			#status()

#func talk():
	#var character = await Global.show_text_choice('Who do you want to talk to?', characters)
	#match character:
		#1:
			#Dialogue.kobaneko()
		#2:
			#Dialogue.white()
	#return


func func_palace():
	return


func func_demonitorium():
	await Global.show_text_box('', "Unholy sigils paint the walls and howling creatures cackle from cages hanging precariously overhead")
	await Global.show_text_box("Crowley", "Test your skills, adventurer... Anything you carve out is yours.")
	await Global.show_text_box("Crowley", "Whatever you want, I got it.")
	while true:
		var option = await Global.show_text_choice("Crowley", "What would you like to purchase? ", ["Buy Mag", "See Demons", "Talk to Crowley"])
		match option:
			1:
				var x
				while true:
					#try:
					#var x = int(await Global.show_text_box("How much do you want to buy: [number] "))
					break
					#except ValueError:
					continue
				var cost = 10 * x
				var confirm = await Global.show_text_choice("Crowley", "That will be {cost} yen. | Balance: {players.gold}")
				if confirm:
					if players.gold >= cost:
						players.gold -= cost
						#players.mag += x
					else:
						await Global.show_text_box('System', "You don't have enough Yen")
			2:
				var fights = players.demon_training
				while true:
					var fight = await Global.show_text_choice('What do you want to fight', fights)
					#try:
					var cost = fights[fight]
					var confirm =  await Global.show_text_choice("Crowley", "That will be {cost} yen | Balance: {players.gold}")
					if confirm:
						if players.gold >= cost:
							var enemy
							#enemy = getattr(enemy_models, fight)()
							Global.battle_scene.instantiate()
							Global.battle_scene.stuff = [players, [enemy]]
						else:
							await Global.show_text_box('', "Broke ass n*gga")
					#except KeyError:
						break
			3:
				crowley.crowley()
			_:
				break
	return


func status():
	while true:
		var view = await Global.show_text_choice("System", "What do you want to do?", ['Stats', 'Equipment', 'Magic', 'Save'])
		match view:
			1:
				var text_ = \
				'Name: {players.name}' + \
				'HP: {players.hp}/{players.max_hp} | SP: {players.sp}/{players.max_sp}' + \
				'Class: {players.__class__.__name__}' + \
				'Stats : {players.stats}' + \
				'Weapon:'

				await Global.show_text_box('', text_)
				#for i in players.gear_parts:
					##try:
					#await Global.show_text_box('\t{i.capitalize()}: {players.gear[i].name} - {players.gear[i].stats}')
					##except AttributeError:
					#await Global.show_text_box('\t{i.capitalize()}: None')
				#await Global.show_text_box('Inventory:')
				players.display_inventory()
			2:
				var weapons
				#weapons = [i for i in players.inventory if isinstance(i, Base_Gear)]
				if len(weapons) == 0:
					#await Global.show_text_box('No equipment in inventory')
					continue
				#weapon_dict = {i.name: i.stats for i in weapons}
				#while true:
					#try:
						#equip = Global.show_text_choice('Which gear do you want to equip', weapon_dict)
						#for weapon in weapons:
							#if weapon.name == equip:
								#confirm = Global.show_text_choice(f"Confirm", back=false)
								#if confirm:
									#players.equip_gear(weapon)
									#await Global.show_text_box(f'{equip} equipped!')
								#break
						#continue
					#except KeyError:
						#break
			#3:
				#await Global.show_text_box('Unavailable')
			#4:
				#save.save(players)
				#await Global.show_text_box('Progress saved!')
			_:
				break
	return
