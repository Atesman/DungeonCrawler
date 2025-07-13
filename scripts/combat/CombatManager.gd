extends Node

const Player = preload("res://scripts/characters/player/Player.gd")
const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

const CombatTurnManager = preload("res://scripts/combat/CombatTurnManager.gd")
const CombatActionProcessor = preload("res://scripts/combat/CombatActionProcessor.gd")
const CombatUIController = preload("res://scripts/combat/CombatUIController.gd")

signal input_lock_changed(locked: bool)

var character_overlay: Node = null # need to be here?

var turn_manager: CombatTurnManager
var action_processor: CombatActionProcessor
var ui_controller: CombatUIController

var current_character: BaseCharacter
var combat_ended: bool = false
var input_locked: bool = false
var is_targeting: bool = false
var pending_action: String = ""
var delay_between_enemy_actions := 0.9


func start_combat(order: Array[BaseCharacter], anchors: Dictionary) -> void:
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay")
	_instantiate_combat_helpers(order, character_overlay, anchors)
	EventBus.emit_signal("combat_ready")
	start_turn()


func _instantiate_combat_helpers(order: Array[BaseCharacter], overlay: Node, anchors: Dictionary):
	turn_manager = CombatTurnManager.new()
	add_child(turn_manager)
	turn_manager.set_turn_order(order)
	
	action_processor = CombatActionProcessor.new()
	add_child(action_processor)
	action_processor.setup(overlay, anchors, turn_manager)

	ui_controller = CombatUIController.new()
	add_child(ui_controller)
	ui_controller.setup()
	ui_controller.action_requested.connect(_on_action_selected)
	

func start_turn():
	current_character = turn_manager.get_current_character()
	if current_character is Player:
		await wait_seconds(0.01)
		_unlock_input()
		enemies_choose_actions()
		current_character.reset_actions()
		current_character.reset_def()
	else:
		_lock_input()
		var actions_queue = current_character.get_actions()
		process_enemy_actions(actions_queue)


func _on_action_selected(action: String) -> void:
	if input_locked:
		return
	if action == "defend":
		exit_targeting_mode()
		_lock_input()
		await action_processor.process_player_action(action, null)
		_unlock_input()
		action_used()
	elif action == "move" and current_character.currently_engaged:
		var target = action_processor.get_close_enemy()
		_lock_input()
		await action_processor.process_player_action(action, target)
		_unlock_input()
		action_used()
	else:
		enter_targeting_mode(action)
		if turn_manager.get_turn_order().size() == 2:
			var target = turn_manager.next_in_line()
			on_enemy_clicked(target)


func on_enemy_clicked(target: BaseCharacter): #Will always be Player
	if not is_targeting or input_locked:
		return
	_lock_input()
	await action_processor.process_player_action(pending_action, target)
	_unlock_input()
	action_used()


func process_enemy_actions(actions_queue: Array[String]):
	var skip_next = false
	for action in actions_queue:
		if combat_ended:
			return
		if skip_next:
			skip_next = false
			continue
		if action == "engage" and not RunManager.current_game_state.get_player().currently_engaged:
			skip_next = true
		if action == "disengage" and RunManager.current_game_state.get_player().currently_engaged:
			skip_next = true	
		await action_processor.process_enemy_action(current_character, action)
		action_used()
		await wait_seconds(delay_between_enemy_actions)


func enter_targeting_mode(action: String):
	is_targeting = true
	pending_action = action


func exit_targeting_mode():
	is_targeting = false
	pending_action = ""


func _lock_input(): # add signals to interact with combat options ui
	input_locked = true
	emit_signal("input_lock_changed", true)


func _unlock_input(): # add signals to interact with combat options ui
	input_locked = false
	emit_signal("input_lock_changed", false)


func enemies_choose_actions():
	for character in turn_manager.get_turn_order():
		if character is Enemy:
			character.choose_actions()


func _enemies_reset():
	for character in turn_manager.get_turn_order():
		if character is Enemy:
			character.reset_actions()
			character.reset_def()


func end_turn():
	if current_character is Player:
		_lock_input()
		_enemies_reset()
	exit_targeting_mode()
	await wait_seconds(delay_between_enemy_actions)
	turn_manager.next_turn()
	start_turn()


func action_used():
	death_check()
	exit_targeting_mode()
	if current_character.has_no_actions():
		end_turn()


func death_check():
	for character in turn_manager.get_turn_order():
		var outcome = action_processor.death_check(character)
		if outcome == "":
			continue
		else:
			end_combat(outcome)


func end_combat(result: String):
	combat_ended = true
	_lock_input()
	RunManager.current_game_state.clear_current_enemies()
	if result == "victory":
		RunManager.current_game_state.current_floor = RunManager.current_game_state.current_floor + 1
		SceneManager.add_ui("res://scenes/ui/CombatVictory.tscn")
	else:
		RunManager.current_game_state.current_floor = 1
		SceneManager.add_ui("res://scenes/ui/CombatDefeat.tscn")


func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
