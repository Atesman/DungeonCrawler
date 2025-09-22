extends Node
class_name MapNode

var id: String
var type: String
var location: Vector2
var room_entered: bool

var incoming_nodes: Array = []
var outgoing_nodes: Array = []
var edges: Array = []


func _init(id: String, node_type: String) -> void:
	self.id = id
	self.type = node_type
	self.room_entered = false


func _ready() -> void:
	pass