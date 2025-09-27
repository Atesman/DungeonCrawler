extends Control

@onready var MapNodeButtonScene = preload("res://scenes/overlay/MapNodeButton.tscn")

var map_nodes: Array[Array]
var map_edges: Array[Array]


func _ready() -> void:
	map_nodes = RunManager.current_game_state.map_nodes
	map_edges = RunManager.current_game_state.map_edges
	draw_edges()
	create_node_buttons()


func create_node_buttons():
	for i in range(map_nodes.size()):
		for j in range(map_nodes[i].size()):
			var node = map_nodes[i][j]
			var button = MapNodeButtonScene.instantiate()
			button.setup(node.type)

			var canvas_xform = get_viewport().get_canvas_transform()
			var screen_position = canvas_xform * node.location
			var half_size = Vector2(40, 40)							# HARDCODED
			button.position = screen_position - half_size

			add_child(button)


func draw_edges():	#Line2D nodes are also an option
	for floor in map_edges:
		for edge in floor:
			var line = Line2D.new()
			line.points = [edge.start, edge.end]
			line.width = 8.0
			line.default_color = Color.html("#383838")
			add_child(line)