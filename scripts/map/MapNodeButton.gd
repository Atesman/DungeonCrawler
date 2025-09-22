extends Node
class_name MapNodeButton

var type: String


func setup(node_type: String):
	type = node_type
	match node_type:
		"combat":
			self.icon = preload("res://assets/map_nodes/combat_node.png")
		"story":
			self.icon = preload("res://assets/map_nodes/story_node.png")
		"elite":
			self.icon = preload("res://assets/map_nodes/elite_node.png")
		"boss":
			self.icon = preload("res://assets/map_nodes/boss_node.png")


func _ready() -> void:
	pass


func on_pressed():
	pass	#emit signal?
