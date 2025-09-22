extends Node
class_name MapGeneration

const floors: int = 9
const min_encounters: int = 2
const max_encounters: int = 4

const NODE_COMBAT := "combat"
const NODE_STORY  := "story"
const NODE_ELITE  := "elite"
const NODE_BOSS  := "boss"

const story_chance: float = 0.25
const elite_chance: float = 0.07

const entrance: int = 280
const boss_location: int = 1700
const boss_offset: int = 30
const floor: int = 1050
const ceiling: int = 30


static func generate_map() -> Array[Array]:
	var encounter_amounts = generate_number_of_encounters()
	var map_node_planner = create_planner(encounter_amounts)
	add_story_encounters(map_node_planner)
	add_elites(map_node_planner)
	add_boss(map_node_planner)
	var map_nodes = create_nodes(map_node_planner)
	# add edges
	set_locations(map_nodes)
	return map_nodes	#return edges as well


static func generate_number_of_encounters() -> Array[int]:
	var encounters: Array[int] = []
	encounters.resize(floors)
	for i in range (floors):
		if i == 0:
			encounters[i] = min_encounters
		else:
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
			floor_set[j] = NODE_COMBAT
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
	var new_name: String = ""
	new_name += "F"
	new_name += str((floor + 1)).pad_zeros(2)
	new_name += "R"
	new_name += str((room + 1)).pad_zeros(2)
	return new_name


static func set_locations(map_nodes: Array[Array]):
	var column_locations = set_columns(map_nodes.size())
	for i in range(map_nodes.size()):
		var row_locations = set_rows(map_nodes[i].size())
		for j in range(map_nodes[i].size()):
			var location_vector = Vector2(column_locations[i], row_locations[j])
			map_nodes[i][j].location = location_vector


static func set_columns(floor_amount: int) -> Array[int]:
	var length: int = (boss_location - boss_offset) - entrance
	var length_segment: int = floor((length / (floor_amount - 1)))
	var columns: Array[int] = []
	columns.append(entrance)
	var current_column := entrance
	for i in range (floor_amount - 2):
		current_column += length_segment
		columns.append(current_column)
	columns.append(boss_location)
	return columns


static func set_rows(room_amount: int) -> Array[int]:
	var height: int = floor - ceiling
	var height_segment: int = ceil((height / (room_amount + 1)))
	var rows: Array[int] = []
	var current_row = ceiling
	for i in range(room_amount):
		current_row += height_segment
		rows.append(current_row)
	return rows
