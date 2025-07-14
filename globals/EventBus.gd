extends Node

# Combat Cycle
signal combat_ready()
#signal combat_ended()

# Turn Cycle
#signal turn_started(character)
#signal turn_ended(character)

# Death
signal turn_order_changed(turn_order)




# Action events
#signal action_used(user, ability_name, target)
#signal attack_performed(attacker, target, damage)

# Status & data changes
#signal health_changed(character, old_hp, new_hp)
#signal stat_modified(character, stat_name, old_value, new_value)


signal set_effects_up()
