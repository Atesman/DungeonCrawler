extends Node


func _ready() -> void:
	pass


func create_ability(target: BaseCharacter, ability_name: String, data: Array) -> Node:
	var path = "res://scripts/abilities/%s.gd" % ability_name
	var ability_script = load(path)
	var ability_instance = ability_script.new()
	ability_instance.init(target, data)
	return ability_instance
