extends Node

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

var turn_order: Array[BaseCharacter]
var current_turn_index: int = 0


func set_turn_order(order: Array[BaseCharacter]) -> void:
	turn_order = order
	current_turn_index = 0
	EventBus.emit_signal("turn_order_changed", turn_order)


func get_current_character() -> BaseCharacter:
	return turn_order[current_turn_index]


func next_turn() -> void:
	current_turn_index = (current_turn_index + 1) % turn_order.size()


func remove_from_turn_order(character: BaseCharacter) -> void:# implementation?
	turn_order.erase(character)
	if current_turn_index >= turn_order.size():
		current_turn_index = 0
	EventBus.emit_signal("turn_order_changed", turn_order)


func get_turn_order() -> Array[BaseCharacter]:
	return turn_order


func next_in_line() -> BaseCharacter:
	return turn_order[(current_turn_index + 1) % turn_order.size()]


#func get_living_enemies() -> Array[BaseCharacter]:
#	return turn_order.filter(func(c): return c is Enemy and c.current_hp > 0)