extends Node

const CharacterUIWrapperScene := preload("res://scenes/overlay/characterDisplay/CharacterUIWrapper.tscn")

var overlay_map:= {}


func add_character_overlay(character: Node) -> void:
	var wrapper = CharacterUIWrapperScene.instantiate()
	wrapper.character = character
	add_child(wrapper)
	overlay_map[character] = wrapper


func remove_character_overlay(character: Node) -> void:
	if overlay_map.has(character):
		overlay_map[character].queue_free()
		overlay_map.erase(character)


func move_positions(character: Node, anchor: Vector2):
	if overlay_map.has(character):
		overlay_map[character].update_positions(anchor)
