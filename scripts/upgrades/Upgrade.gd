extends Node
class_name Upgrade

enum Type { INSTANT, PERMANENT, COMBAT }

var upgrade_owner: Node = null
var upgrade_name: String = ""
var upgrade_type: Type
var display_value: int


func _init(character: Node, _name: String, init_data: Array):
	upgrade_owner = character
	upgrade_name = _name
	if init_data.size() > 0:
		display_value = init_data[0]
	_handle_init_data(init_data)
	_connect_signals()


func are_obtained() -> void:
	if upgrade_type == Type.INSTANT:
		fire()


# Base Upgrade
func _handle_init_data(data: Array): pass
func _connect_signals(): pass
func fire(): pass