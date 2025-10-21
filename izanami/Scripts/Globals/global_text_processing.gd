extends Node

class_name GlobalTextProcessing

#var active_tags: Array[String] = ['br']

func add_to_text_log(dialogue: Array):
	if not get_parent().text_log:
		get_parent().text_log = get_parent().text_log_scene.instantiate()

	get_parent().text_log.label.append_text(await process_text_tags(dialogue[0], false) + '\n')
	get_parent().text_log.label.push_indent(2)
	get_parent().text_log.label.append_text(await process_text_tags(dialogue[1], false) + '\n')
	if dialogue.size() >= 3:
		get_parent().text_log.label.push_list(3, RichTextLabel.LIST_DOTS, true)
		for i in dialogue[2]:
			get_parent().text_log.label.append_text(await process_text_tags(i.name, false) + '\n')
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

func process_text_tags(text: String, active: bool = true):
	var search_result: Array = Global.custom_tags_filter.search_all(text)
	if search_result:
		text = await process_custom_tag(search_result, text, active)

	return text

func process_custom_tag(result: Array[RegExMatch], _text: String, active: bool = true) -> String:
	for i in result:
		var replacement_text := ''
		match i.get_string(Global.REGEX_TAG_GROUP):
			'br': await _break(i, active)
			'gr': replacement_text = _whisper(i)
			'sm': replacement_text = _small(i)
			'pl': replacement_text = _player()

		_text = Global.custom_tags_filter.sub(_text, replacement_text)

	return _text

#region Tags
func _break(result: RegExMatch, active: bool):
	if active: await get_tree().create_timer(result.get_string(Global.REGEX_VALUE_GROUP).to_int()).timeout

func _whisper(result: RegExMatch) -> String:
	if result.get_string(Global.REGEX_SLASH_GROUP):
		return r'[/color]'
	else :
		return '[color=#%s]' % [Checks.retreive_setting('thought_text_colour').to_html()]

func _small(result: RegExMatch) -> String:
	if result.get_string(Global.REGEX_SLASH_GROUP):
		return r'[/font_size]'
	else :
		return '[font_size=%d]' % [Checks.retreive_setting('small_text_size')]

func _player() -> String:
	return Checks.player_name
#endregion
