extends PanelContainer

class_name DescriptionBox

@export var type: Label
@export var element: Label
@export var value: Label
@export var effect_name: Label
@export var effect_chance: Label
@export var description: Label
@export var subtype: Label
@export var target_scope: Label
@export var sell_price: Label
@export var weapon_status: Label
@export var cost: Label
@export var stats: Label
@export var rank: Label

func convert_stats_to_text(_stats: Variant) -> String:
	var stats_string = ''
	for i in _stats:
		if _stats is Dictionary:
			if _stats[i] != 0:
				stats_string += i + ': ' + str(_stats[i]) + ' '
		elif _stats is Array:
			stats_string = " ".join(_stats)
	return stats_string

func set_status_info(object: Resource):
	if object.status_effect.is_empty(): return

	var effects = object.status_effect
	var magnitudes = object.effect_magnitude
	var status_desc_array = []
	for i in effects:
		var _status: Status = i.new()
		if _status is StatusBuff:
			if 'rank' in object:
				_status.magnitude = magnitudes[i]
			else :
				_status.magnitude = magnitudes[i][object.rank]

			if _status.magnitude > 0:
				status_desc_array.append(_status.desc)

	effect_name.text = '|'.join(status_desc_array)
	if effect_name.text:
		effect_chance.text = str(object.effect_chance * 100) + '%'
		effect_name.show()
		effect_chance.show()

func set_scope(object: Resource):
	if object.universal:
		target_scope.text = 'Universal'
	elif object.aoe:
		target_scope.text = 'AOE'
	else:
		target_scope.text = "Single"


func _set_skill(object: Skill):
	type.text = 'Skill'
	stats.text = convert_stats_to_text(object._stats)
	cost.text = str(object.cost) + 'SP'
	#set_status_info(object)
	rank.text = '+'.repeat(object.rank)
	sell_price.text = str(object.crit_chance[object.rank] * 100) + '%'
	set_scope(object)

	value.hide()

func _set_item(object: Item):
	type.text = 'Item'
	value.text = str(object.value)
	#set_status_info(object)
	sell_price.text = '#' + str(object.price)
	subtype.text = object.type
	set_scope(object)
	element.text = object.element

	stats.hide()
	cost.hide()
	rank.hide()

func _set_gear(object: Gear):
	type.text = 'Gear'
	stats.text = convert_stats_to_text(object.stats)
	subtype.text = object.slot
	if object.equipped:
		weapon_status.show()
	sell_price.text = '#' + str(object.price)
	element.text = object.element

	target_scope.hide()
	value.hide()
	cost.hide()
	rank.hide()


func set_info(object: Resource):
	if object is Gear:
		_set_gear(object)
	elif object is Item:
		_set_item(object)
	elif object is Skill:
		_set_skill(object)

	if 'element' in object and object.element:
		element.text = object.element
	else :
		element.hide()

	description.text = object.desc
