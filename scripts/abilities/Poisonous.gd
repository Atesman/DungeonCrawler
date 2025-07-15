extends Ability

var buildup: int


func _handle_init_data(data: Array):
	buildup = data[0]


func _connect_signals():
	ability_owner.connect("health_damaged", Callable(self, "_on_health_damaged"))


func _on_health_damaged(target: BaseCharacter, amount: int):
	var existing_poisoned_instance = target.effects_manager.get_effect("Poisoned")
	if existing_poisoned_instance == null:
		var data = [buildup]
		var poisoned_effect = AbilityManager.create_ability(target, "Poisoned", data)
		target.effects_manager.add_effect(poisoned_effect)
	else:
		existing_poisoned_instance.add_poison_stack(buildup)