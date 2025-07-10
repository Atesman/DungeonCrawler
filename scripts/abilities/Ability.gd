extends Node
class_name Ability

var ability_owner: Node = null


func init(character: Node, init_data: Array) -> void:
	ability_owner = character
	handle_init_data(init_data)
	connect_signals()

func connect_signals(): pass
func handle_init_data(data: Array): pass

#func on_turn_start(): pass
#func on_turn_end(): pass
#func on_attack(target: Node): pass
#func on_receive_damage(amount: int): pass