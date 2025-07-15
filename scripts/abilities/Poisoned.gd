extends Ability

var buildup: int
var loose_health_this_round: bool = true


func _handle_init_data(data: Array):
	buildup = data[0]


func _connect_signals():
	ability_owner.connect("hp_changed", Callable(self, "_on_hp_changed"))
	EventBus.connect("turn_started", Callable(self, "_on_turn_started"))
	EventBus.connect("turn_ended", Callable(self, "_on_turn_ended"))


func deal_poison_damage():
	ability_owner.lose_health(buildup)


func add_poison_stack(stack: int):
	buildup = buildup + stack
	update_display_value(buildup)


func _on_turn_started(character: Node):
	if character != ability_owner:
		return
	if not loose_health_this_round:
		ability_owner.effects_manager.remove_effect(self)
		return
	deal_poison_damage()


func _on_turn_ended(character: Node):
	if character != ability_owner:
		return
	loose_health_this_round = false


func _on_hp_changed(amount: int):
	loose_health_this_round = true

# add a way to lose poison
