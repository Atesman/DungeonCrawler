extends Ability

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

var atk_bonus: int
var previous_bonus_damage = 0

var turn_manager: Node


func _handle_init_data(data: Array):
	atk_bonus = data[0]


func _connect_signals():
	EventBus.connect("turn_order_changed", Callable(self, "_on_turn_order_changed"))


func _on_turn_order_changed(turn_order: Array):
		var bonus_damage = _caclulate_pack_bonus(turn_order)
		var bonus_differential = bonus_damage - previous_bonus_damage
		previous_bonus_damage = bonus_damage
		if bonus_differential == 0:
			return
		else:
			ability_owner.adjust_bonus_damage(bonus_differential)
	

func _caclulate_pack_bonus(turn_order: Array) -> int:
	var ally_amount = -1
	for character in turn_order:
		if character is Enemy:
			ally_amount = (ally_amount + 1)
	var bonus_damage = (ally_amount * atk_bonus)
	return bonus_damage
