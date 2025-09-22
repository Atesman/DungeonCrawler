extends Node

@onready var MapNodeButtonScene = preload("res://scenes/overlay/MapNodeButton.tscn")

var map_nodes: Array[Array]


func _ready() -> void:
	map_nodes = RunManager.current_game_state.map_nodes
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