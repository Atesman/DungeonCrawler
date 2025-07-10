extends Ability

#const Poisoned = preload("res://scripts/abilities/Poisoned.gd")

func handle_init_data(data: Array): pass
func connect_signals(): pass
	#ability_owner.connect("turn_started", self, "_on_turn_start")


#func on_attack(target: Node) -> void:
#	if not target.has_node("Poisoned"):
#		var poison_effect = Poisoned.new(target)
#		poison_effect.name = "Poisoned"
#		target.add_child(poison_effect)
