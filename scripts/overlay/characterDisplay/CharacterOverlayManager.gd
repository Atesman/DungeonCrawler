extends Node

const CharacterUIWrapperScene := preload("res://scenes/overlay/characterDisplay/CharacterUIWrapper.tscn")
const CharacterSpriteWrapperScene = preload("res://scenes/combat/CharacterSpriteWrapper.tscn")

var sprite_map := {}
var overlay_map:= {}


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


func remove_character_overlay(character: Node) -> void:
	if overlay_map.has(character):
		overlay_map[character].queue_free()
		overlay_map.erase(character)
	if sprite_map.has(character):
		sprite_map[character].queue_free()
		sprite_map.erase(character)


func move_positions(character: Node, anchor: Vector2): # get the nide itself
	if overlay_map.has(character):
		overlay_map[character].update_positions(anchor)
	if sprite_map.has(character):			#write logic
		sprite_map[character].update_sprite_position(anchor)
