extends Ability

var buildup: int


func _handle_init_data(data: Array):
	buildup = data[0]


func _connect_signals():
	EventBus.connect("turn_started", Callable(self, "deal_poison_damage"))


func deal_poison_damage(character: Node):
	if character != ability_owner:
		return
	ability_owner.lose_health(buildup)


func add_poison_stack(stack: int):
	buildup = buildup + stack
	update_display_value(buildup)


# add a way to lose poison
