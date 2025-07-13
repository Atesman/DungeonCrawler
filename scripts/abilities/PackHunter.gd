extends Ability

var atk_bonus: int
var previous_bonus_damage = 0


func _handle_init_data(data: Array):
	atk_bonus = data[0]


func _connect_signals():
	EventBus.connect("turn_order_changed", Callable(self, "_on_turn_order_changed"))


func _on_turn_order_changed(turn_order: Array):
		var bonus_damage = _caclulate_pack_bonus()
		var bonus_differential = bonus_damage - previous_bonus_damage
		previous_bonus_damage = bonus_damage
		if bonus_differential == 0:
			return
		else:
			if is_instance_valid(ability_owner):
				ability_owner.adjust_bonus_damage(bonus_differential)
	

func _caclulate_pack_bonus() -> int:
	var ally_amount = (GameState.get_current_enemies().size() - 1)
	var bonus_damage = (ally_amount * atk_bonus)
	return bonus_damage
