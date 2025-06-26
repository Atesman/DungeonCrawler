extends Node

signal action_selected(action: String)

#var combat_manager: Node = null

#func _ready():
	#var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon") # get node and get the instanced version?
	#combat_manager = dungeon.combat_manager

func on_melee_pressed():
	action_selected.emit("melee")


func on_ranged_pressed():
	action_selected.emit("ranged")


func on_defend_pressed():
	action_selected.emit("defend")


func on_item_pressed():
	pass
