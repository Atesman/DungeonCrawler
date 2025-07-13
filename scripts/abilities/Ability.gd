extends Node
class_name Ability

var ability_owner: Node = null
#var icon: path


func _init(character: Node, init_data: Array) -> void:
	ability_owner = character
	_handle_init_data(init_data)
	_connect_signals()


func _handle_init_data(data: Array): pass
func _connect_signals(): pass


func _on_combat_ready(): pass
func _on_turn_order_changed(turn_order: Array): pass

#func on_turn_start(): pass
#func on_turn_end(): pass
#func on_attack(target: Node): pass
#func on_receive_damage(amount: int): pass