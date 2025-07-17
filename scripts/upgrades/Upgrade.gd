extends Node
class_name Upgrade

var upgrade_name: String = ""
var upgrade_type: String # Instant, Permanent, Combat


func _init(_name: String, data: Array):
	upgrade_name = _name
	#upgrade_type = data[0]
	