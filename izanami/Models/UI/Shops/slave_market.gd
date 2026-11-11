extends CharacterSelector

class_name SlaveMarket


var current_slave_cost: int
var menu_view: bool = false

func create_card(player: Player):
	var card: PlayerStatusCard = super.create_card(player)

	card.status_label.text = 'Cost'
	card.status_effect.text = str(player.cost)

	return card

func choose_target(card: PlayerStatusCard):
	menu_view = false
	super.choose_target(card)
	current_slave_cost = int(card.status_effect.text)

func confirm_choice(card: PlayerDetailsCard):
	if Global.players.is_party_full():
		await Global.show_info_popup('No space in party!')
		return

	if Global.players.gold < current_slave_cost:
		Global.sell.emit('low funds')
		return
	else:
		Global.players.gold -= current_slave_cost
		super.confirm_choice(card)
		Global.sell.emit('item bought')
		_on_button_pressed()
		show()

func _on_button_pressed() -> void:
	if not menu_view:
		super._on_button_pressed()
		back_button.show()
		menu_view = true
	else:
		Global.sell.emit('exit')
