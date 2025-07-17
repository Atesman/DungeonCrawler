extends Node

var game_layer: Node = null
var ui_layer: Control = null
var overlay_layer: Control = null
var game_scene_current: Node = null


func set_game_layer(layer: Node) -> void:
	game_layer = layer


func set_ui_layer(layer: Node) -> void:
	ui_layer = layer


func set_overlay_layer(layer: Node) -> void:
	overlay_layer = layer


func change_scene(scene_path: String) -> void:
	for child in game_layer.get_children():
		child.queue_free()
	if game_scene_current:
		game_scene_current.queue_free()
	game_scene_current = load(scene_path).instantiate()
	game_layer.add_child(game_scene_current)


func transition_scene(scene_path: String) -> void:
	var ui_node = load("res://scenes/ui/TransitionFade.tscn").instantiate()
	add_ui_node(ui_node)
	await ui_node.fade_out()
	clear_overlay()
	change_scene(scene_path)
	await ui_node.fade_in()
	clear_ui()
	#remove_ui(ui_node)


func change_ui(scene_path: String) -> void:
	clear_ui()
	add_ui(scene_path)


func add_ui(scene_path: String) -> void:
	#check if this node exists already
	var ui_node = load(scene_path).instantiate()
	ui_layer.add_child(ui_node)


func add_ui_node(ui_node: Control) -> void:
	#check if this node exists already
	ui_layer.add_child(ui_node)


func remove_ui(node: Control) -> void:
	if node and node.get_parent() == ui_layer:
		node.queue_free()


func clear_ui() -> void:
	for child in ui_layer.get_children():
		child.queue_free()


func add_overlay(scene_path: String) -> void:
	#check if this node exists already
	var overlay_node = load(scene_path).instantiate()
	overlay_layer.add_child(overlay_node)


func remove_overlay(node: Control) -> void:
	if node and node.get_parent() == overlay_layer:
		node.queue_free()


func clear_overlay() -> void:
	for child in overlay_layer.get_children():
		child.queue_free()
