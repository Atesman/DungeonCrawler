extends TextureButton
class_name MapNodeButton

var type: String


func setup(node_type: String):
	type = node_type
	match node_type:
		"combat":
			texture_normal = preload("res://assets/map_nodes/combat_node.png")
		"story":
			texture_normal = preload("res://assets/map_nodes/story_node.png")
		"elite":
			texture_normal = preload("res://assets/map_nodes/elite_node.png")
		"boss":
			texture_normal = preload("res://assets/map_nodes/boss_node.png")


func _ready() -> void:
	pass


func on_pressed():
	pass	#emit signal?
