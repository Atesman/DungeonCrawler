extends Node

signal action_requested(action: String)
signal enemy_targeted(target: BaseCharacter)

var options_ui: Control
var character_overlay: Node

func setup() -> void:
	SceneManager.add_overlay("res://scenes/overlay/CombatOptions.tscn")
	options_ui = get_tree().root.get_node("Main/OverlayLayer/CombatOptions")
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay")
	if not options_ui.action_selected.is_connected(_on_action_selected):
		options_ui.action_selected.connect(_on_action_selected)


func _on_action_selected(action: String) -> void:
	action_requested.emit(action)
