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