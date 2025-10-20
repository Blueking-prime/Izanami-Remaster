extends Control

@export var options: Array[Control]

var index: int = 0:
	set(arg):
		if arg < 0: index = options.size() - 1
		if arg >= options.size(): index = 0

func _input(event: InputEvent) -> void:
	if options.size() and is_visible_in_tree():
		#print(self, is_visible_in_tree())
		#print('Shouldnt trigger')
		if event.is_action_pressed('ui_up'):
			index -= 1
			print(options[index], ' focused')
			options[index].grab_focus()
		if event.is_action_pressed('ui_down'):
			index += 1
			print(options[index], ' focused')
			options[index].grab_focus()
