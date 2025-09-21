extends Node
class_name MapGeneration
#const MapNode = preload("res://scripts/map/MapNode.gd")

static var floors: int = 10
static var min_encounters: int = 2
static var max_encounters: int = 4

const NODE_COMBAT := "combat"
const NODE_STORY  := "story"
const NODE_ELITE  := "elite"
const NODE_BOSS  := "boss"

static var story_chance: float = 0.20
static var elite_chance: float = 0.03


static func generate_map() -> Array[Array]:
	var encounter_amounts = generate_number_of_encounters()
	var map_node_planner = create_planner(encounter_amounts)
	add_story_encounters(map_node_planner)
	add_elites(map_node_planner)
	add_boss(map_node_planner)
	var map_nodes = create_nodes(map_node_planner)
	# add edges
	return map_nodes	#return edges as well


static func generate_number_of_encounters() -> Array[int]:
	var encounters: Array[int] = []
	encounters.resize(floors)
	for i in range (floors):
		var amount = randi_range(min_encounters, max_encounters)
		encounters[i] = amount
	return encounters


static func create_planner(encounter_amounts: Array[int]) -> Array[Array]:
	var planner: Array[Array] = []
	planner.resize(encounter_amounts.size())
	for i in range (encounter_amounts.size()):
		var floor_set: Array[String] = []
		floor_set.resize(encounter_amounts[i])
		for j in range (encounter_amounts[i]):
			floor_set[j] = NODE_STORY
		planner[i] = floor_set
	return planner


static func add_story_encounters(planner: Array[Array]):
	for i in range (planner.size()):
		for j in range (planner[i].size()):
			var number = randf()
			if number < story_chance:
				planner[i][j] = NODE_STORY


static func add_elites(planner: Array[Array]):
	for i in range (planner.size()):
		for j in range (planner[i].size()):
			var number = randf()
			if number < elite_chance:
				planner[i][j] = NODE_ELITE


static func add_boss(planner: Array[Array]):
	var boss_floor: Array[String] = []
	boss_floor.append(NODE_BOSS)
	planner.append(boss_floor)


static func create_nodes(planner: Array[Array]) -> Array[Array]:
	var node_grid: Array[Array] = []
	for i in range (planner.size()):
		var floor_nodes: Array[MapNode] = []
		for j in range (planner[i].size()):
			var node_type = planner[i][j]
			var node_id = name_map_node(i, j)
			var node = MapNode.new(node_id, node_type)
			floor_nodes.append(node)
		node_grid.append(floor_nodes)
	return node_grid


static func name_map_node(floor: int, room: int) -> String:
	var name: String = ""
	name += "F"
	name += str((floor + 1)).pad_zeros(2)
	name += "R"
	name += str((room + 1)).pad_zeros(2)
	return name
