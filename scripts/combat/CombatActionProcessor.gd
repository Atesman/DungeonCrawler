extends Node

var player_ref = RunManager.current_game_state.get_player()
var turn_manager: Node

var character_overlay: Node
var character_anchor_points: Dictionary
var close_quarter_characters := {
	"player": null,
	"enemy": null
}


func setup(overlay: Node, anchors: Dictionary, turn_manager_node: Node):
	character_overlay = overlay
	character_anchor_points = anchors
	turn_manager = turn_manager_node


func process_player_action(action: String, target: BaseCharacter) -> void:
	var in_melee_range = (close_quarter_characters["enemy"] == target)
	match action:
		"attack":
			if in_melee_range:
				await _play_melee_animation(player_ref)
			else:
				await _play_ranged_animation(player_ref)
			var damage = player_ref.attack(in_melee_range)
			player_ref.deal_damage_to(target, damage)
		"defend":
			await _play_defend_animation(player_ref)
			player_ref.defend()
		"move":
			await _move_player(target)
		_:
			pass

	player_ref.use_action()


func process_enemy_action(enemy: Node, action: String):
	var in_melee_range = (close_quarter_characters["enemy"] == enemy)
	match action:
		"attack":
			if in_melee_range:
				await _play_melee_animation(enemy)
			else:
				await _play_ranged_animation(enemy)
			var damage = enemy.attack(in_melee_range)
			enemy.deal_damage_to(player_ref, damage)
		"defend":
			await _play_defend_animation(enemy)
			enemy.defend()
		"engage":
			if player_ref.currently_engaged:
				return
			await _enemy_engage(enemy)
		"disengage":
			if not player_ref.currently_engaged:
				return
			await _enemy_disengage(enemy)
		_:
			pass
	enemy.use_action()


func death_check(character: Node) -> String:
	if character.current_hp <= 0:	
		if character == player_ref:
			return("defeat")
		else:
			if close_quarter_characters["enemy"] == character:
				_player_disengage(character)
			character_overlay.remove_character_overlay(character)
			if turn_manager.get_turn_order().size() == 2:
				return("victory")
			RunManager.current_game_state.remove_enemy(character)
			turn_manager.remove_from_turn_order(character) # will this cause issues with turn order and indexing? # remove from game state current enemies. 
			return("")
	return("")
			

func _move_player(target: Node):
	if player_ref.currently_engaged:
		_player_disengage(target)
	else:
		_player_engage(target)


func _player_engage(target: Node):
	player_ref.engage()
	target.engage()
	_set_close_quarters(player_ref, target)
	_handle_player_engage_move(target)
	SoundManager.play_sfx("move")


func _player_disengage(target: Node):
	player_ref.disengage()
	target.disengage()
	_clear_close_quarters()
	_handle_player_disengage_move(target)
	SoundManager.play_sfx("move")


func _enemy_engage(enemy: Node):
	player_ref.engage()
	enemy.engage()
	_set_close_quarters(player_ref, enemy)
	_handle_enemy_engage_move(enemy)
	SoundManager.play_sfx("move")


func _enemy_disengage(enemy: Node):
	player_ref.disengage()
	enemy.disengage()
	_clear_close_quarters()
	_handle_enemy_disengage_move(enemy)
	SoundManager.play_sfx("move")


func _play_melee_animation(attacker: BaseCharacter) -> void:
	character_overlay.show_action(attacker, "melee")
	var wrapper = character_overlay.sprite_map.get(attacker)
	if wrapper:
		await wrapper.play_attack_animation()


func _play_ranged_animation(attacker: BaseCharacter) -> void:
	character_overlay.show_action(attacker, "ranged")
	var wrapper = character_overlay.sprite_map.get(attacker)
	if wrapper:
		await wrapper.play_attack_animation()
		

func _play_defend_animation(character: BaseCharacter) -> void:
	character_overlay.show_action(character, "defend")
	var wrapper = character_overlay.sprite_map.get(character)
	if wrapper:
		await wrapper.play_defend_animation()


func _set_close_quarters(player: Node, enemy: Node):
	close_quarter_characters["player"] = player
	close_quarter_characters["enemy"] = enemy


func _clear_close_quarters():
	close_quarter_characters["player"] = null
	close_quarter_characters["enemy"] = null


func _handle_player_engage_move(target: Node):
	var anchor_group = character_anchor_points[target]
	var anchor = anchor_group["engage"]
	await character_overlay.move_positions(player_ref, anchor)


func _handle_player_disengage_move(target: Node):
	var player_anchors = character_anchor_points[player_ref]
	var player_spawn_anchor = player_anchors["spawn"]
	await character_overlay.move_positions(player_ref, player_spawn_anchor)

	var enemy_anchors = character_anchor_points[target]
	var enemy_spawn_anchor = enemy_anchors["spawn"]
	await character_overlay.move_positions(target, enemy_spawn_anchor)

	
func _handle_enemy_engage_move(enemy: Node):
	var anchor_group = character_anchor_points[player_ref]
	var anchor = anchor_group["engage"]
	await character_overlay.move_positions(enemy, anchor)


func _handle_enemy_disengage_move(enemy: Node):
	var player_anchors = character_anchor_points[player_ref]
	var player_spawn_anchor = player_anchors["spawn"]
	await character_overlay.move_positions(player_ref, player_spawn_anchor)

	var enemy_anchors = character_anchor_points[enemy]
	var enemy_spawn_anchor = enemy_anchors["spawn"]
	await character_overlay.move_positions(enemy, enemy_spawn_anchor)


func get_close_enemy() -> Node:
	return close_quarter_characters["enemy"]