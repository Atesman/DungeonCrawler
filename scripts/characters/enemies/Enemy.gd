extends BaseCharacter

signal intent_changed(current_intent: String)

var action_probabilities: Dictionary
var actions_queue: Array[String]
#var combat_manager: Node = null



func _ready():
    var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon")
    #combat_manager = dungeon.combat_manager


func create_enemy(blueprint: Dictionary) -> void:
    set_core_stats(blueprint)
    action_probabilities = blueprint["action_probabilities"]


func choose_actions() -> void:
    actions_queue.clear()
    
    for i in range(max_actions):
            var action = random_choice()
            actions_queue.append(action)

    var current_intent := ""
    for i in actions_queue.size():
        current_intent += actions_queue[i]
        if i < actions_queue.size() - 1:
            current_intent += " - "
    emit_signal("intent_changed", current_intent)


func random_choice() -> String:
    var cumulative_probability := 0.0
    var random_value = randf()
    for action in action_probabilities.keys():
        cumulative_probability += action_probabilities[action]
        if random_value < cumulative_probability:
            return action
    return action_probabilities.keys()[-1]


func get_actions() -> Array[String]:
    return actions_queue
