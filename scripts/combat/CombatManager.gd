extends Node

const Player = preload("res://scripts/characters/player/Player.gd")
const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

const CombatTurnManager = preload("res://scripts/combat/CombatTurnManager.gd")
const CombatActionProcessor = preload("res://scripts/combat/CombatActionProcessor.gd")

var options_ui: Node
var character_overlay: Node = null # need to be here?

var turn_manager: CombatTurnManager
var action_processor: CombatActionProcessor

var current_character: BaseCharacter
var combat_ended: bool = false
var input_locked: bool = false
var is_targeting: bool = false
var pending_action: String = ""
var delay_between_enemy_actions := 1.2


func start_combat(order: Array[BaseCharacter], anchors: Dictionary) -> void:
	SceneManager.add_overlay("res://scenes/overlay/CombatOptions.tscn")
	options_ui = get_tree().root.get_node("Main/OverlayLayer/CombatOptions")
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay")
	instantiate_combat_helpers(order, character_overlay, anchors)
	start_turn()


func instantiate_combat_helpers(order: Array[BaseCharacter], overlay: Node, anchors: Dictionary):
	turn_manager = CombatTurnManager.new()
	turn_manager.set_turn_order(order)
	add_child(turn_manager)

	action_processor = CombatActionProcessor.new()
	action_processor.setup(overlay, anchors, turn_manager)
	add_child(action_processor)


func start_turn():
	current_character = turn_manager.get_current_character()
	if current_character is Player:
		await wait_seconds(0.01)
		input_locked = false
		enemies_choose_actions()
		current_character.reset_actions()
		current_character.reset_def()
		take_player_input()
	else:
		input_locked = true
		var actions_queue = current_character.get_actions()
		process_enemy_actions(actions_queue)


func take_player_input():
	if not options_ui.action_selected.is_connected(_on_action_selected):
		options_ui.action_selected.connect(_on_action_selected)


func _on_action_selected(action: String) -> void:
	if input_locked:
		return
	if action == "defend":
		input_locked = true
		exit_targeting_mode()
		await action_processor.process_player_action(action, null)
		input_locked = false
		action_used()
	elif action == "move" and current_character.currently_engaged:
		input_locked = true
		var target = action_processor.get_close_enemy()
		await action_processor.process_player_action(action, target)
		input_locked = false
		action_used()
	else:
		enter_targeting_mode(action)
		if turn_manager.get_turn_order().size() == 2:
			var target = turn_manager.next_in_line()
			on_enemy_clicked(target)


func enter_targeting_mode(action: String):
	is_targeting = true
	pending_action = action


func exit_targeting_mode():
	is_targeting = false
	pending_action = ""


func on_enemy_clicked(target: BaseCharacter): #Will always be Player
	if not is_targeting or input_locked:
		return
	input_locked = true
	await action_processor.process_player_action(pending_action, target)
	input_locked = false
	action_used()


func player_move_logic(target: Node):
	#if current_character.currently_engaged:
	#	current_character.disengage()
	#	target.disengage()

	#	close_quarter_characters["player"] = null
	#	close_quarter_characters["enemy"] = null

	#	var player_anchors = character_anchor_points[current_character]
	#	var player_spawn_anchor = player_anchors["spawn"]
		input_locked = true													#quick attacks can happen while moving
	#	await character_overlay.move_positions(current_character, player_spawn_anchor)
	#	var enemy_anchors = character_anchor_points[target]
	#	var enemy_spawn_anchor = enemy_anchors["spawn"]
	#	await character_overlay.move_positions(target, enemy_spawn_anchor)
		input_locked = false
	#else:
	#	current_character.engage()
	#	target.engage()

	#	close_quarter_characters["player"] = current_character
	#	close_quarter_characters["enemy"] = target

	#	var target_anchor_info = character_anchor_points[target]
	#	var target_anchor = target_anchor_info["engage"]
		input_locked = true		
	#	await character_overlay.move_positions(current_character, target_anchor)
		input_locked = false


func enemies_choose_actions():
	for character in turn_manager.get_turn_order():
		if character is Enemy:
			character.choose_actions()


func enemies_reset_action_points():
	for character in turn_manager.get_turn_order():
		if character is Enemy:
			character.reset_actions()


func enemies_reset_def():
	for character in turn_manager.get_turn_order():
		if character is Enemy:
			character.reset_def()


func process_enemy_actions(actions_queue: Array[String]):
	var skip_next = false
	for action in actions_queue:
		if combat_ended:
			return
		if skip_next:
			skip_next = false
			continue
		if action == "engage" and not GameState.get_player().currently_engaged:
			skip_next = true
		if action == "disengage" and GameState.get_player().currently_engaged:
			skip_next = true	
		await action_processor.process_enemy_action(current_character, action)
		action_used()
		await wait_seconds(delay_between_enemy_actions)


func end_turn():
	if current_character is Player:
		if options_ui.action_selected.is_connected(_on_action_selected):
			options_ui.action_selected.disconnect(_on_action_selected)
		enemies_reset_action_points()
		enemies_reset_def()
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
		var outcome = action_processor.death_check(character, turn_manager.get_turn_order().size())
		if outcome == "":
			continue
		else:
			end_combat(outcome)


func end_combat(result: String):
	combat_ended = true
	GameState.clear_current_enemies()
	if result == "victory":
		GameState.current_floor = GameState.current_floor + 1
		SceneManager.add_ui("res://scenes/ui/CombatVictory.tscn")
	else:
		GameState.current_floor = 1
		SceneManager.add_ui("res://scenes/ui/CombatDefeat.tscn")


func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
