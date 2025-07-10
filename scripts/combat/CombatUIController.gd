extends Node

signal action_requested(action: String)
signal enemy_targeted(target: BaseCharacter)

var options_ui: Control
var character_overlay: Node

func setup() -> void:
	SceneManager.add_overlay("res://scenes/overlay/CombatOptions.tscn")
	options_ui = get_tree().root.get_node("Main/OverlayLayer/CombatOptions")
	add_child(options_ui)
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay")

	if not options_ui.action_selected.is_connected(_on_action_selected):
		options_ui.action_selected.connect(_on_action_selected)

	var combat_manager = get_tree().root.get_node("Main/GameLayer/Dungeon/CombatManager")
	if not combat_manager.input_lock_changed.is_connected(options_ui._input_is_locked):
		combat_manager.input_lock_changed.connect(options_ui._input_is_locked)


func _on_action_selected(action: String) -> void:
	action_requested.emit(action)
