extends Node

signal action_selected(action: String)

#var combat_manager: Node = null

#func _ready():
	#var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon") # get node and get the instanced version?
	#combat_manager = dungeon.combat_manager

func on_attack_pressed():
	action_selected.emit("attack")


func on_move_pressed():
	action_selected.emit("move")


func on_defend_pressed():
	action_selected.emit("defend")


func on_item_pressed():
	pass
