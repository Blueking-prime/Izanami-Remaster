extends OptionMenu

class_name DemonitariumFightsUI

## EXTERNAL PARAMETERS
#@export var desc_box_container: BoxContainer
@export var players: Party
@export var demon_group: ResourceGroup

## WORKING VARIABLES
@export var demons: Dictionary

## SIGNAL
signal fight_demon(demon)

func _ready() -> void:
	#Global.description_box_parent = desc_box_container
	#Global.sell.connect(_sell)
	display_demons()

#func _sell(cond: String):
	#print(cond)
	#Global.sell.disconnect(_sell)

func display_demons():
	if demon_group:
		demons.clear()
		for i in demon_group.load_all():
			var enemy: Enemy = i.instantiate()
			demons.get_or_add(enemy.name, {
				'scene'			: i,
				'stats'			: enemy.stats,
				'sprite_texture': enemy.battle_sprite_texture.texture,
				'lvl'			: enemy.lvl,
				'price'			: enemy.stats.values().reduce(func(accum, x): return accum + (10 * x), 10)
			})
		update_listing()

func update_listing():
	options.clear()

	for i in demons:
		options.add_icon_item(
			demons[i].sprite_texture,
			i,
			[
				_process_desc_text(demons[i]),
				str(demons[i].price)
			]
		)

func _process_desc_text(entry: Dictionary) -> String:
	var desc_text = ''
	for i in entry.stats:
		desc_text += i + ': ' + str(entry.stats[i]) + ' '

	desc_text += '\n'

	#desc_text += str(entry.element) + '\n'

	desc_text += str(entry.lvl)

	return desc_text

#func add_entry(entry: Variant):
	#if entry.name in demons:
		#demons[entry.name].append(entry)
	#else:
		#demons.get_or_add(entry.name, [entry])
	#update_listing()

#func remove_item(entry: Variant):
	#demons[entry.name].erase(entry)
	#if not len(demons[entry.name]):
		#demons.erase(entry.name)
	#update_listing()

#func _get_item(demon_name: String):
	#return demons[demon_name]

func fight_entry(id: int):
	var demon = demons[options.get_item_text(id)]
	if not _check_price(demon):
		return


func _check_price(demon: Dictionary) -> bool:
	if demon.price <= players.gold:
		players.gold -= demon.price
		fight_demon.emit(demon.scene)
		return true
	else:
		Global.sell.emit('low funds')
		return false

func _on_item_activated(index: int) -> void:
	var confirm = await Global.show_text_choice("Crowley", 'Are you sure about that one?')
	if confirm == 0:
		fight_entry(index)
	else:
		Global.show_text_box("Crowley", 'What do you want to fight?', true)
