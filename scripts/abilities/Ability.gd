extends Node
class_name Ability

var owner: Node = null


func _init(_owner: Node) -> void:
	owner = _owner

func on_turn_start(): pass
func on_turn_end(): pass
func on_attack(target: Node): pass
func on_receive_damage(amount: int): pass