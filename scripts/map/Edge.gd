extends Node
class_name Edge

var from_node: MapNode
var to_node: MapNode
var start: Vector2
var end: Vector2


func _init(from: MapNode, to: MapNode) -> void:
	from_node = from
	to_node = to
	start = from.location
	end = to.location
