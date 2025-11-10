extends Node


func _ready() -> void:
	pass


func create_upgrade(target: Node, upgrade_name: String, data: Array) -> Node:
	var path = "res://scripts/upgrades/%s.gd" % upgrade_name
	var upgrade_script = load(path)
	var upgrade_instance = upgrade_script.new(target, upgrade_name, data)
	return upgrade_instance
