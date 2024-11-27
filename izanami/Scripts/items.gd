extends Node

#@export_dir var item_location: String
@export var _items: Array[Item] = []
@export var item_group: ResourceGroup
@export var _item_dict: Dictionary

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	item_group.load_all_into(_items)
	_update_dict()

func add_item(item: Item):
	#var item = load(item_location + '/' + item_name + '.tres') as Item
	_items.append(item)
	_update_dict()

func _update_dict():
	_item_dict.clear()
	for i in _items:
		if i.name in _item_dict:
			_item_dict[i] += 1
		else:
			_item_dict.get_or_add(i.name, 1)

func get_item(item_name: String):
	for i in _items:
		if i.name == item_name:
			return i
	print('No such item')

func remove_item(item: Item):
	_items.erase(item)
	_update_dict()

func get_items():
	return _item_dict
