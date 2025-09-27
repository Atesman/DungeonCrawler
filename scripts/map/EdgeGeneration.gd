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
		var extra_edge_amount = target_connection_amount - edge_planner.size()
		var extra_edges = add_extra_edges(floor_A.size(), floor_B.size(), extra_edge_amount, edge_planner)
		edge_planner.append_array(extra_edges)
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
		var index = randi_range(0, partition.size() - 1)
		partition[index] = partition[index] + 1
		crowded_edge_amount = crowded_edge_amount - 1

	var i: int = 0
	for j in range(partition.size()):
		while(partition[j] > 0):
			var edge = Vector2(i, j)
			edges.append(edge)
			i = i + 1
			partition[j] = partition[j] - 1

	if(swapped):
		for k in range(edges.size()):
			edges[k] = Vector2(edges[k].y, edges[k].x)

	return edges


static func add_extra_edges(floor_A_size: int, floor_B_size: int, extra_amount: int, edge_planner: Array[Vector2]) -> Array[Vector2]:
	var extra_edges: Array[Vector2] = []

	#create ALL pairs
	var candidate_pool: Array[Vector2] = []
	for i in range(floor_A_size):
		for j in range(floor_B_size):
			var potential_edge = Vector2(i, j)
			candidate_pool.append(potential_edge)
	#for base_edge in edge_planner:
	#	for candidate_edge in candidate_pool:
	#		if candidate_edge.x == base_edge.x && candidate_edge.y == base_edge.y:


	#remove pairs already in planner
	candidate_pool = candidate_pool.filter(
		func(c):
			return not edge_planner.has(c)
	)

	#remove pairs that would cross
	var impossible_edges: Array[Vector2] = []
	var edges_cross: bool
	for base_edge in edge_planner:
		for candidate_edge in candidate_pool:
			edges_cross = would_cross(base_edge, candidate_edge)
			if(edges_cross):
				impossible_edges.append(candidate_edge)
	for bad_edge in impossible_edges:
		candidate_pool.erase(bad_edge)


	# loop for how many extra edges needed
	for k in range(extra_amount):

		#look at candidates, pick one, add to extra_edges
		var choice = candidate_pool.pick_random()
		extra_edges.append(choice)
		candidate_pool.erase(choice)

		#recalculate candidates including new edge
		var newly_bad_edges: Array[Vector2] = []
		for candidate_edge in candidate_pool:
			edges_cross = would_cross(choice, candidate_edge)
			if(edges_cross):
				newly_bad_edges.append(candidate_edge)
		for bad_edge2 in newly_bad_edges:
			candidate_pool.erase(bad_edge2)

	return extra_edges


static func would_cross(base: Vector2, extra: Vector2) -> bool:
	var does_cross: bool = false
	var b1 = int(base.x)
	var b2 = int(base.y)
	var e1 = int(extra.x)
	var e2 = int(extra.y)
	if((b1 < e1 and  b2 > e2) or (b1 > e1 and  b2 < e2)):
		does_cross = true
	return does_cross


static func create_floor_edges(floor_A: Array[MapNode], floor_B: Array[MapNode], edge_planner: Array[Vector2]) -> Array[Edge]:
	var edges: Array[Edge] = []
	for i in range(edge_planner.size()):
		var a_room_index = edge_planner[i].x
		var b_room_index = edge_planner[i].y
		var from = floor_A[a_room_index]
		var to = floor_B[b_room_index]
		var new_edge = Edge.new(from, to)
		edges.append(new_edge)
	return edges