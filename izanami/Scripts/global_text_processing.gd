extends Node


class_name GlobalTextProcessing


func add_to_text_log(dialogue: Array):
	if not get_parent().text_log:
		get_parent().text_log = get_parent().text_log_scene.instantiate()
	get_parent().text_log.label.append_text(clear_custom_tags(dialogue[0]) + '\n')
	get_parent().text_log.label.push_indent(2)
	get_parent().text_log.label.append_text(clear_custom_tags(dialogue[1]) + '\n')
	if dialogue.size() >= 3:
		get_parent().text_log.label.push_list(3, RichTextLabel.LIST_DOTS, true)
		for i in dialogue[2]:
			get_parent().text_log.label.append_text(clear_custom_tags(i) + '\n')
	get_parent().text_log.label.pop_all()
	get_parent().text_log.label.newline()


func clear_custom_tags(_text: String) -> String:
	_text = get_parent().custom_tags_filter.sub(_text, '', true)

	return _text

func print_to_log(text: Variant):
	if not get_parent().action_log: return

	if text is String:
		get_parent().action_log.text += '\n' + text
	else :
		get_parent().action_log.text += '\n' + str(text)
