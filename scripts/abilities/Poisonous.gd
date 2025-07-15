extends Ability

var buildup: int


func _handle_init_data(data: Array):
	buildup = data[0]


func _connect_signals():
	ability_owner.connect("health_damaged", Callable(self, "_on_turn_order_changed"))


func _on_health_damaged(target: BaseCharacter, amount: int):
	pass
	#apply poison to target