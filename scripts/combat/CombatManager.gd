extends Node

const Player = preload("res://scripts/characters/player/Player.gd")
const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

var options_ui: Node

var turn_order: Array[BaseCharacter]
var current_turn_index: int = 0
var current_character: BaseCharacter

var is_targeting: bool = false
var pending_action: String = ""
var delay_between_enemy_actions := 1.5

var close_quarter_characters := {
    "player": null,
    "enemy": null
}


func start_combat(order: Array[BaseCharacter]) -> void:
	turn_order = order
	SceneManager.add_overlay("res://scenes/overlay/CombatOptions.tscn")
	options_ui = get_tree().root.get_node("Main/OverlayLayer/CombatOptions")
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
		#current_character.combat_manager = self
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
			target.recieve_damage(current_character.attack())
		"move":
			if current_character.currently_engaged:
				current_character.disengage()
				close_quarter_characters["player"] = null
				close_quarter_characters["enemy"] = null

			else:
				current_character.engage()
				close_quarter_characters["player"] = current_character
				close_quarter_characters["enemy"] = target
		_:
			print("Unknown Action: ", pending_action)

	current_character.use_action()
	action_used()


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


func process_enemy_actions(actions_queue: Array[String]):
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
	#check for player death
	#check for all enemies dead
	exit_targeting_mode()
	if current_character.has_no_actions():
		end_turn()


func death_check():
	pass


func end_combat():
	pass


func wait_seconds(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
