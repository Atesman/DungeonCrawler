extends Node
class_name EdgeGeneration


static func generate_edges(map_nodes: Array[Array]) -> Array[Array]:
	var edges: Array[Array] = []
	edges.resize(map_nodes.size())
	for i in range((map_nodes.size() - 1)):
		var floor_edges = connect_floors(map_nodes[i], map_nodes[i+1])
		edges[i] = floor_edges
	return edges


static func connect_floors(floor_A: Array[MapNode], floor_B: Array[MapNode]) -> Array[Edge]:
	var edge_planner: Array[Vector2] = []
	var target_connection_amount = decide_connection_amount(floor_A.size(), floor_B.size())
	edge_planner = build_base_edges(floor_A.size(), floor_B.size())
	if edge_planner.size() < target_connection_amount:
		var extra_edges = add_extra_edges(floor_A, floor_B, edge_planner)
		edge_planner.append(extra_edges)
	var edges = create_floor_edges(floor_A, floor_B, edge_planner)
	return edges


static func decide_connection_amount(a_size: int, b_size: int) -> int:
	var min_connections = max(a_size, b_size)
	var max_connections = (a_size + b_size) - 1
	var target = randi_range(min_connections, max_connections)
	return target


static func build_base_edges(floor_A_size: int, floor_B_size: int) -> Array[Vector2]:
	var edges: Array[Vector2] = []
	var first_floor_size: int = 0
	var second_floor_size: int = 0
	var swapped: bool = false

	if(floor_A_size < floor_B_size):
		first_floor_size = floor_B_size
		second_floor_size = floor_A_size
		swapped = true
	else:
		first_floor_size = floor_A_size
		second_floor_size = floor_B_size

	var partition: Array[int] = []
	partition.resize(second_floor_size)
	partition.fill(1)

	var crowded_edge_amount = first_floor_size - second_floor_size
	while(crowded_edge_amount > 0):
		var index = randi_range(0, partition.size())
		partition[index] = partition[index] + 1
		crowded_edge_amount = crowded_edge_amount - 1
	
	for i in range(first_floor_size):
		for j in range(partition[i]):
			var edge = Vector2(i, j)
			edges.append(edge)

	if(swapped):
		for i in range(edges.size()):
			edges[i] = Vector2(edges[i].y, edges[i].x)

	return edges


static func add_extra_edges(floor_A: Array[MapNode], floor_B: Array[MapNode], edge_planner: Array[Vector2]) -> Array[Vector2]:
	var extra_edges: Array[Vector2] = []

	#STUB

	return extra_edges


static func create_floor_edges(floor_A: Array[MapNode], floor_B: Array[MapNode], edge_planner: Array[Vector2]) -> Array[Edge]:
	var edges: Array[Edge] = []
	for i in range(edge_planner.size()):
		var a_room_index = edge_planner[1].x
		var b_room_index = edge_planner[i].y
		var from = floor_A[a_room_index]
		var to = floor_B[b_room_index]
		var new_edge = Edge.new(from, to)
		edges.append(new_edge)
	return edges