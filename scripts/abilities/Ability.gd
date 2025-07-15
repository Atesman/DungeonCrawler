extends Node
class_name Ability

signal display_value_updated(display_value)

var ability_owner: Node = null
var ability_name: String = ""
var display_value: int = 0


func _init(character: Node, name: String, init_data: Array) -> void:
	ability_owner = character
	ability_name = name
	if init_data.size() > 0:
		display_value = init_data[0]
	_handle_init_data(init_data)
	_connect_signals()


func update_display_value(value: int):
	display_value = value
	emit_signal("display_value_updated", display_value)

# Base Ability
func _handle_init_data(data: Array): pass
func _connect_signals(): pass

# Combat Cycle
func _on_combat_ready(): pass

# Turn Cycle
func _on_turn_started(character: BaseCharacter): pass
func _on_turn_ended(character: BaseCharacter): pass

# Health/Death
func _on_turn_order_changed(turn_order: Array): pass
func _on_health_damaged(target: BaseCharacter, amount: int): pass
func _on_hp_changed(amount: int): pass

