extends Node
class_name MapNode

var id: String
var type: String

var incoming_nodes: Array = []
var outgoing_nodes: Array = []
var edges: Array = []


func _init(id: String, node_type: String) -> void:
	self.id = id
	self.type = node_type


func _ready() -> void:
	pass