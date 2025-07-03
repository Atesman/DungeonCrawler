extends Node

const Player = preload("res://scripts/characters/player/Player.gd")
const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

var options_ui: Node
var character_overlay: Node = null

var turn_order: Array[BaseCharacter]
var current_turn_index: int = 0
var current_character: BaseCharacter

var is_targeting: bool = false
var pending_action: String = ""
var delay_between_enemy_actions := 1.2

var character_anchor_points: Dictionary = {}
var close_quarter_characters := {
    "player": null,
    "enemy": null
}


func start_combat(order: Array[BaseCharacter], anchors: Dictionary) -> void:
	turn_order = order
	character_anchor_points = anchors
	SceneManager.add_overlay("res://scenes/overlay/CombatOptions.tscn")
	options_ui = get_tree().root.get_node("Main/OverlayLayer/CombatOptions")
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay") # move to ready
	enemies_choose_actions()
	start_turn()


func start_turn():
	current_character = turn_order[current_turn_index]
	
	if current_character is Player:
		enemies_choose_actions()
		current_character.reset_actions()
		current_character.reset_def()
		take_player_input()
	else:
		var actions_queue = current_character.get_actions()
		process_enemy_actions(actions_queue)


func take_player_input():
	if not options_ui.action_selected.is_connected(_on_action_selected):
		options_ui.action_selected.connect(_on_action_selected)


func _on_action_selected(action: String) -> void:
	if action == "defend":
		exit_targeting_mode()
		current_character.defend()
		current_character.use_action()
		action_used()
	elif action == "move" and current_character.currently_engaged:
		var target = close_quarter_characters["enemy"]
		player_move_logic(target)
		current_character.use_action()
		action_used()
	else:
		enter_targeting_mode(action)
		if turn_order.size() == 2:# Need to remove characters from turn order on death
			var target = turn_order[(current_turn_index + 1) % turn_order.size()]
			on_enemy_clicked(target)


func enter_targeting_mode(action: String):
	is_targeting = true
	pending_action = action


func exit_targeting_mode():
	is_targeting = false
	pending_action = ""


func on_enemy_clicked(target: BaseCharacter): #Will always be Player
	if not is_targeting:
		return

	match pending_action:
		"attack":
			var sprite_wrapper = character_overlay.sprite_map.get(current_character)
			if sprite_wrapper:
				sprite_wrapper.play_attack_animation()
			SoundManager.play_attack_sound()
			target.recieve_damage(current_character.attack())
		"move":
			player_move_logic(target)
		_:
			print("Unknown Action: ", pending_action)
	current_character.use_action()
	action_used()


func player_move_logic(target: Node):
	if current_character.currently_engaged:
		current_character.disengage()
		close_quarter_characters["player"] = null
		close_quarter_characters["enemy"] = null

		var player_anchors = character_anchor_points[current_character]
		var player_spawn_anchor = player_anchors["spawn"]
		character_overlay.move_positions(current_character, player_spawn_anchor)

		var enemy_anchors = character_anchor_points[target]
		var enemy_spawn_anchor = enemy_anchors["spawn"]
		character_overlay.move_positions(target, enemy_spawn_anchor)
	else:
		current_character.engage()
		close_quarter_characters["player"] = current_character
		close_quarter_characters["enemy"] = target

		var target_anchor_info = character_anchor_points[target]
		var target_anchor = target_anchor_info["engage"]
		character_overlay.move_positions(current_character, target_anchor)


func enemies_choose_actions():
	for character in turn_order:
		if character is Enemy:
			character.choose_actions()


func enemies_reset_action_points():
	for character in turn_order:
		if character is Enemy:
			character.reset_actions()


func enemies_reset_def():
	for character in turn_order:
		if character is Enemy:
			character.reset_def()


func process_enemy_actions(actions_queue: Array[String]): #MOVEMENT
	for action in actions_queue:
		match action:
			"attack":
				enemy_attack()
			"defend":
				current_character.defend()
				current_character.use_action()
				action_used()
			"move":
				if current_character.currently_engaged:
					current_character.disengage()
					close_quarter_characters["player"] = null
					close_quarter_characters["enemy"] = null

				else:
					current_character.engage()
					close_quarter_characters["player"] = GameState.get_player()
					close_quarter_characters["enemy"] = current_character
			_:
				print("Unknown action: ", action)
		await wait_seconds(delay_between_enemy_actions)


func enemy_attack():
	var sprite_wrapper = character_overlay.sprite_map.get(current_character)
	if sprite_wrapper:
		sprite_wrapper.play_attack_animation()
	SoundManager.play_attack_sound()
	GameState.get_player().recieve_damage(current_character.attack())
	current_character.use_action()
	action_used()


func end_turn():
	if current_character is Player:
		if options_ui.action_selected.is_connected(_on_action_selected):
			options_ui.action_selected.disconnect(_on_action_selected)
		enemies_reset_action_points()
		enemies_reset_def()
	exit_targeting_mode()
	await wait_seconds(delay_between_enemy_actions)
	current_turn_index = (current_turn_index + 1) % turn_order.size()
	start_turn()


func action_used():
	death_check()
	exit_targeting_mode()
	if current_character.has_no_actions():
		end_turn()


func death_check():
	for character in turn_order:
		if character.current_hp <= 0:	
			if character == GameState.get_player():
				end_combat("defeat")
			else:
				if close_quarter_characters["enemy"] == character:
					close_quarter_characters["player"].disengage()

					var player = GameState.get_player()					# send this to player move decisions
					var player_anchors = character_anchor_points[player]
					var player_spawn_anchor = player_anchors["spawn"]
					character_overlay.move_positions(player, player_spawn_anchor)

					close_quarter_characters["player"] = null
					close_quarter_characters["enemy"] = null

				character_overlay.remove_character_overlay(character)

				if turn_order.size() == 2:
					end_combat("victory")
				
				turn_order.erase(character) # will this cause issues with turn order and indexing?


func end_combat(result: String):
	GameState.current_floor = GameState.current_floor + 1
	GameState.clear_current_enemies()

	if result == "victory":
		SceneManager.add_ui("res://scenes/ui/CombatVictory.tscn")
	else:
		SceneManager.add_ui("res://scenes/ui/CombatDefeat.tscn")


func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
