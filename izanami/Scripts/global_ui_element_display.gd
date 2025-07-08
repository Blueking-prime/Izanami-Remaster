extends Node

class_name GlobalUIElements

func show_text_choice(speaker: String, prompt: String, choices: Array = ['Yes', 'No'], screen_side: String = 'L', dialogue: bool = false) -> int:
	_create_base_textbox(speaker, prompt, screen_side, dialogue)

	get_parent().text_box.options.clear()
	for i in choices:
		get_parent().text_box.options.add_item(i)

	get_parent().text_box.options.grab_focus()

	await get_parent().text_box.options.item_activated

	get_parent().text_box.queue_free()

	return get_parent().textbox_response


func show_text_box(speaker: String, prompt: String, persist: bool = false, screen_side: String = 'L', dialogue: bool = false) -> void:
	_create_base_textbox(speaker, prompt, screen_side, dialogue)

	get_parent().text_box.spacer.hide()
	get_parent().text_box.options.hide()

	if not persist:
		await get_parent().next
		get_parent().text_box.queue_free()


func _create_base_textbox(speaker: String, prompt: String, screen_side: String = 'L', dialogue: bool = false) -> void:
	if is_instance_valid(get_parent().text_box):
		get_parent().text_box.queue_free()
	if not is_instance_valid(get_parent().text_log):
		get_parent().text_log = get_parent().text_log_scene.instantiate()

	add_text_log_to_scene()

	get_parent().text_box = get_parent().text_box_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(get_parent().text_box)
	get_parent().move_node_to_other_node(get_parent().text_box, get_tree().get_current_scene().canvas_layer, get_parent().text_log)

	get_parent().text_box.title.text = speaker

	if Checks.scroll:
		get_parent().text_box.text_string = prompt
		get_parent().text_box.scroll_text()
	else:
		get_parent().text_box.text.text = get_parent().clear_custom_tags(prompt)

	match screen_side:
		'L': get_parent().text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		'C': get_parent().text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_CENTER
		'R': get_parent().text_box.title_container.size_flags_horizontal = Control.SIZE_SHRINK_END

	if not dialogue:
		get_parent().add_to_text_log([speaker, prompt])
		get_parent().text_box.button_panel.hide()

	_connect_text_box_signals()

	if get_parent().textbox_auto_flag:
		get_parent().text_box.auto_button.set_pressed_no_signal(true)
	if get_parent().text_log.visible:
		get_parent().text_box.log_button.button_pressed = true

	#print('MOUSE POSITION: ', get_window().get_mouse_position())
	#print('GET WINDOW: ', get_window().size)
	#print('GET VIEWPORT: ', get_viewport().size)
	#print('DISPLAY SERVER: ', DisplayServer.screen_get_size())
	#get_window().warp_mouse(
		#Vector2(
			#get_window().size.x * 0.5 + (get_parent().text_box.offset_right * 0.9),
			#get_window().size.y * (get_parent().text_box.anchor_top + get_parent().text_box.anchor_bottom) / 2
		#)
	#)
	#print('UPDATED MOUSE POSITION: ', get_window().get_mouse_position())


func show_confirmation_box(prompt: String):
	if is_instance_valid(get_parent().confirmation_box):
		get_parent().confirmation_box.queue_free()

	get_parent().confirmation_box = get_parent().confirmation_box_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(get_parent().confirmation_box)

	get_parent().confirmation_box.dialog_text = prompt
	get_parent().confirmation_box.get_label().horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	get_parent().confirmation_box.get_label().vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	get_parent().confirmation_box.canceled.connect(get_parent()._confirmation_box_canceled)
	get_parent().confirmation_box.confirmed.connect(get_parent()._confirmation_box_confirmed)

	await get_parent().confirmation_box_triggered

	return get_parent().confrimation_response


func change_background(texture: Texture2D, global: bool = false):
	if texture:
		if not is_instance_valid(get_parent().background_texture):
			get_parent().background_texture = TextureRect.new()
			get_parent().background_texture.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			get_parent().background_texture.set_anchors_preset(Control.PRESET_FULL_RECT)
			if not global:
				get_tree().current_scene.canvas_layer.get_child(0).add_sibling(get_parent().background_texture)
			else:
				get_parent().root_canvas_layer = CanvasLayer.new()
				get_tree().root.add_child.call_deferred(get_parent().root_canvas_layer)
				get_parent().root_canvas_layer.add_child.call_deferred(get_parent().background_texture)

		get_parent().background_texture.texture = texture
	else:
		if is_instance_valid(get_parent().background_texture):
			if not global:
				get_tree().current_scene.canvas_layer.remove_child(get_parent().background_texture)
			else :
				#get_parent().root_canvas_layer.remove_child(get_parent().background_texture)
				get_tree().root.remove_child.call_deferred(get_parent().root_canvas_layer)
			get_parent().background_texture.queue_free()
			get_parent().root_canvas_layer.queue_free()


func show_description(object: Resource) -> void:
	if is_instance_valid(get_parent().description_box):
		get_parent().description_box.queue_free()

	get_parent().description_box = get_parent().description_box_scene.instantiate()

	if get_parent().description_box_parent:
		get_parent().description_box_parent.add_child(get_parent().description_box)
	else:
		get_tree().get_current_scene().canvas_layer.add_child(get_parent().description_box)

	if 'stats' in object:
		var stats_string = ''
		for i in object.stats:
			if object.stats is Dictionary:
				if object.stats[i] != 0:
					stats_string += i + ': ' + str(object.stats[i]) + ' '
			else:
				stats_string += i + ' '
		get_parent().description_box.stats.text = stats_string
	else:
		get_parent().description_box.stats.hide()

	get_parent().description_box.cost.hide()

	if object is Gear:
		get_parent().description_box.type.text = 'Gear'
		get_parent().description_box.subtype.text = object.slot
		if object.equipped:
			get_parent().description_box.weapon_status.show()
		get_parent().description_box.effect_chance.hide()
		get_parent().description_box.target_scope.hide()
		get_parent().description_box.value.hide()
	else:
		if object is Item:
			get_parent().description_box.type.text = 'Item'
			get_parent().description_box.effect_chance.text = str(object.effect_chance * 100) + '%'
		if object is Skill:
			get_parent().description_box.type.text = 'Skill'
			get_parent().description_box.cost.show()
			get_parent().description_box.cost.text = str(object.cost)
			get_parent().description_box.effect_chance.text = str(object.effect_chance[object.rank] * 100) + '%'
			if object.rank > 0:
				get_parent().description_box.rank.text = '+'.repeat(object.rank)
				get_parent().description_box.rank.show()

		if object.value != 0:
			get_parent().description_box.value.text = str(object.value)
		elif object.status_effect:
			get_parent().description_box.value.text = object.status_effect.new().desc
		else:
			get_parent().description_box.value.hide()

		get_parent().description_box.subtype.text = object.type
		if object.aoe:
			get_parent().description_box.target_scope.text = 'AOE'
		if object.universal:
			get_parent().description_box.target_scope.text = 'Universal'
		else:
			get_parent().description_box.target_scope.text = "Single"
		get_parent().description_box.weapon_status.hide()

	if 'price' in object:
		get_parent().description_box.sell_price.text = '#' + str(object.price)
	elif object is Skill:
		get_parent().description_box.sell_price.text = str(object.crit_chance[object.rank] * 100) + '%'
	else:
		get_parent().description_box.sell_price.hide()

	if 'element' in object:
		get_parent().description_box.element.text = object.element
	get_parent().description_box.description.text = object.desc


func show_shop_menu(stock: ResourceGroup):
	if is_instance_valid(get_parent().shop_menu):
		get_parent().shop_menu.queue_free()

	get_parent().shop_menu = get_parent().shop_menu_scene.instantiate()

	get_tree().get_current_scene().canvas_layer.add_child(get_parent().shop_menu)

	get_parent().move_node_to_other_node(
		get_parent().shop_menu,
		get_tree().get_current_scene().canvas_layer,
		get_parent().exit_button
	)

	get_parent().shop_menu.shop_inventory.item_group = stock

	get_parent().shop_menu.shop_inventory.load_stock()
	get_parent().shop_menu.player_inventory.load_stock()

	get_parent().exit_button.show()


func _connect_text_box_signals():
	get_parent().text_box.options.item_activated.connect(get_parent()._on_option_selected)

	if get_parent().text_box.button_panel.visible:
		get_parent().text_box.auto_button.toggled.connect(get_parent()._on_textbox_auto_selected)
		get_parent().text_box.ffwd_button.toggled.connect(get_parent()._on_textbox_ffwd_selected)
		get_parent().text_box.log_button.toggled.connect(get_parent()._on_textbox_log_selected)
		get_parent().text_box.skip_button.pressed.connect(get_parent()._on_textbox_skip_selected)

func add_text_log_to_scene():
	if not get_parent().text_log.get_parent():
		get_tree().get_current_scene().canvas_layer.add_child(get_parent().text_log)
