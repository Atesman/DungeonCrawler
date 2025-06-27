extends Node

@onready var combat_manager = $CombatManager
@onready var player_actor = $CombatActors/PlayerActor
@onready var enemy_actors = $CombatActors/EnemyActors

const Enemy = preload("res://scripts/characters/enemies/Enemy.gd")

var player_ref: Node = null
var enemies_ref: Array[Enemy] = []
var actor_spawn_points: Dictionary = {}
var character_anchor_points: Dictionary = {}
var character_overlay: Node = null



func _ready():
	GameState.create_current_enemies()
	player_ref = GameState.get_player()
	enemies_ref = GameState.get_current_enemies()

	SceneManager.add_overlay("res://scenes/overlay/characterDisplay/CharacterOverlay.tscn")
	character_overlay = get_tree().root.get_node("Main/OverlayLayer/CharacterOverlay")

	load_player()
	load_enemies()
	var turn_order = decide_turn_order()
	combat_manager.start_combat(turn_order, character_anchor_points)


func load_player():
	var player_combat_scene = load("res://scenes/combat/PlayerCombatScene.tscn").instantiate() # holds sprite and recognizes click events # move into overlay layer?
	player_actor.add_child(player_combat_scene)
	player_combat_scene.position = $PlayerSpawn.position
	actor_spawn_points[player_ref] = $PlayerSpawn
	character_anchor_points[player_ref] = {
		"spawn": $PlayerSpawn.position,
		"engage": $PlayerEngage.position
	}
	character_overlay.add_character_overlay(player_ref)


func load_enemies():
	var enemy_counter: int = 0
	for enemy_character in enemies_ref:
		var enemy_combat_scene = load("res://scenes/combat/EnemyCombatScene.tscn").instantiate()
		enemy_combat_scene.enemy_ref = enemy_character
		enemy_actors.add_child(enemy_combat_scene)

		var spawn_path = "EnemySpawn%d" % enemy_counter
		var spawn_node = get_node(spawn_path)
		enemy_combat_scene.position = spawn_node.position
		actor_spawn_points[enemy_character] = spawn_node

		var engage_path = "EnemyEngage%d" % enemy_counter
		var engage_node = get_node(engage_path)

		character_anchor_points[enemy_character] = {
			"spawn": spawn_node.position,
			"engage": engage_node.position
		}

		character_overlay.add_character_overlay(enemy_character)
		enemy_counter = (enemy_counter + 1)	


func decide_turn_order() -> Array[BaseCharacter]:
	var turn_order: Array[BaseCharacter] = []
	turn_order.append(player_ref)
	for enemy_character in enemies_ref:
		turn_order.append(enemy_character)
	return turn_order
