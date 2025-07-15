extends Node

signal effect_added(effect); 
signal effect_removed(effect)

var active_effects := []


func _init():
	pass


func _ready():
	pass


func add_effect(effect: Node):
	active_effects.append(effect)
	emit_signal("effect_added", effect)


func remove_effect(effect: Node):
	active_effects.erase(effect)
	emit_signal("effect_removed", effect)


func get_effect(effect_name: String) -> Node:
	var requested_effect = null
	for effect in active_effects:
		if effect.ability_name == effect_name:
			requested_effect = effect
	return requested_effect