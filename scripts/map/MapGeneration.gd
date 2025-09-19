extends Node
class_name MapGeneration

#var nodes: Array[MapNode] = []
#var edges: Array[Edge] = []

var floors: int = 10
var min_encounters: int = 2
var max_encounters: int = 4

var mapNode_default_type = "combat"
var story_chance = 0.25


func _ready() -> void:
	pass


func generate_map():
	var encounter_amounts = generate_number_of_encounters()
	var map_node_planner = create_planner(encounter_amounts)
	var storied_planner = add_story_encounters(map_node_planner)
	# add story encounters
	# add elites
	# turn planner into nodes
	# add edges


func generate_number_of_encounters():
	var encounters: Array[int]
	for i in range (floors):
		var amount = randi_range(min_encounters, max_encounters)
		encounters.append(amount)
	return encounters


func create_planner(encounter_amounts: Array[int]):
	var map_node_planner: Array[Array] = []
	for i in range (encounter_amounts.size()):
		var floor_set: Array[String]
		for j in range (encounter_amounts[i]):
			floor_set.append(mapNode_default_type)					# Create / Set ID here?
		map_node_planner.append(floor_set)
	return map_node_planner


func add_story_encounters()
	pass