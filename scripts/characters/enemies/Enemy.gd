extends BaseCharacter
class_name Enemy

signal intent_changed(current_intent: String)

var melee_affinity: float
var action_probabilities: Dictionary
var actions_queue: Array[String]
var starting_abilities: Dictionary


func _init(blueprint: Dictionary):
	super._init(blueprint)
	melee_affinity = blueprint["melee_affinity"]
	action_probabilities = blueprint["action_probabilities"]
	starting_abilities = blueprint.get("abilities", {})
	

func _ready():
	super._ready()
	EventBus.connect("set_effects_up", Callable(self, "set_innate_abilities"))


func set_innate_abilities():
	for ability in starting_abilities.keys():
		var data = starting_abilities[ability]
		var ability_instance = AbilityManager.create_ability(self, ability, data)
		effects_manager.add_effect(ability_instance)


func choose_actions() -> void:
	actions_queue.clear()
	
	for i in range(max_actions):
		var action = random_choice()
		actions_queue.append(action)

	var intended_movement = decide_to_move()
	if intended_movement != "":
		actions_queue.insert(0, intended_movement)

	send_intent_signal()


func send_intent_signal():
	var current_intent := ""
	var start_index := 0

	var first_action = actions_queue[0]
	if first_action == "engage" or first_action == "disengage":
		current_intent += first_action + "(" + actions_queue[1] + ")"
		start_index = 2  # work with only one base action?
		if actions_queue.size() > 2:
			current_intent += " - "

	for i in range(start_index, actions_queue.size()):
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


func decide_to_move() -> String:
	var random_value = randf()
	if currently_engaged:
		if random_value < (1.0 - melee_affinity):
			return "disengage"
		else:
			return ""
	else:
		if random_value < melee_affinity:
			return "engage"
		else:
			return ""


