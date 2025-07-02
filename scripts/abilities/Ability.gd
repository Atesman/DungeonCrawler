extends Node
class_name Ability

var ability_owner: Node = null


func _init(character: Node) -> void:
	ability_owner = character

func on_turn_start(): pass
func on_turn_end(): pass
func on_attack(target: Node): pass
func on_receive_damage(amount: int): pass