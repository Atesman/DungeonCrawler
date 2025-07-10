extends Node

const CharacterUIWrapperScene := preload("res://scenes/overlay/characterDisplay/CharacterUIWrapper.tscn")
const CharacterSpriteWrapperScene = preload("res://scenes/combat/CharacterSpriteWrapper.tscn")

var sprite_map := {}
var overlay_map:= {}
var last_anchor_map := {}


func add_character_overlay(character: Node) -> void:
	var sprite_wrapper = CharacterSpriteWrapperScene.instantiate()
	sprite_wrapper.character = character
	var dungeon = get_tree().root.get_node("Main/GameLayer/Dungeon")
	var spawn_position = dungeon.actor_spawn_points.get(character).global_position
	sprite_wrapper.global_position = spawn_position
	dungeon.get_node("CombatActors").add_child(sprite_wrapper)
	sprite_map[character] = sprite_wrapper

	var wrapper = CharacterUIWrapperScene.instantiate()
	wrapper.character = character
	add_child(wrapper)
	overlay_map[character] = wrapper

	last_anchor_map[character] = spawn_position


func remove_character_overlay(character: Node) -> void:
	if overlay_map.has(character):
		overlay_map[character].queue_free()
		overlay_map.erase(character)
	if sprite_map.has(character):
		sprite_map[character].queue_free()
		sprite_map.erase(character)


func move_positions(character: Node, anchor: Vector2):
	if last_anchor_map.get(character) == anchor:
		return
	last_anchor_map[character] = anchor

	if overlay_map.has(character):
		overlay_map[character].begin_movement_animation()
		if sprite_map.has(character):
			await sprite_map[character].update_sprite_position(anchor)
		overlay_map[character].update_positions(anchor)
		overlay_map[character].end_movement_animation()


func show_action(character: Node, action: String):
	if overlay_map.has(character):
		overlay_map[character].action_display.show_action(action)
