extends Node

@onready var combat_manager = $CombatManager

var player_ref: Node = null
var enemies_ref: Array[Enemy] = []
var actor_spawn_points: Dictionary = {}
var character_anchor_points: Dictionary = {}
var character_overlay: Node = null


func _ready():
	RunManager.current_game_state.create_current_enemies()
	player_ref = RunManager.current_game_state.get_player()
	enemies_ref = RunManager.current_game_state.get_current_enemies()

	SceneManager.add_overlay("res://scenes/overlay/characterDisplay/CharacterOverlay.tscn")
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay")

	load_player()
	load_enemies()
	EventBus.emit_signal("set_effects_up")
	var turn_order = decide_turn_order()
	combat_manager.start_combat(turn_order, character_anchor_points)


func load_player():
	actor_spawn_points[player_ref] = $PlayerSpawn
	character_anchor_points[player_ref] = {
		"spawn": $PlayerSpawn.position,
		"engage": $PlayerEngage.position
	}
	character_overlay.add_character_overlay(player_ref)


func load_enemies():
	var enemy_counter: int = 0
	for enemy_character in enemies_ref:
		var spawn_path = "EnemySpawn%d" % enemy_counter
		var spawn_node = get_node(spawn_path)
		actor_spawn_points[enemy_character] = spawn_node

		var engage_path = "EnemyEngage%d" % enemy_counter
		var engage_node = get_node(engage_path)

		character_anchor_points[enemy_character] = {
			"spawn": spawn_node.position,
			"engage": engage_node.position
		}

		add_child(enemy_character)

		character_overlay.add_character_overlay(enemy_character)
		enemy_counter = (enemy_counter + 1)	


func decide_turn_order() -> Array[BaseCharacter]:
	var turn_order: Array[BaseCharacter] = []
	turn_order.append(player_ref)
	for enemy_character in enemies_ref:
		turn_order.append(enemy_character)
	return turn_order
