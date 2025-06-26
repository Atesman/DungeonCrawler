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




# NONE OF THIS BELOW IS BEING USED CURRENTLY

const HealthBarScene := preload("res://scenes/overlay/characterDisplay/HealthBar.tscn")
const HealthBar = preload("res://scripts/overlay/characterDisplay/HealthBar.gd")
const ActionPointsDisplayScene := preload("res://scenes/overlay/characterDisplay/ActionPointsDisplay.tscn")
const ActionPointsDisplay = preload("res://scripts/overlay/characterDisplay/ActionPointsDisplay.gd")
const DefenseDisplayScene := preload("res://scenes/overlay/characterDisplay/DefenseDisplay.tscn")
const DefenseDisplay = preload("res://scripts/overlay/characterDisplay/DefenseDisplay.gd")


func create_bar_for(character: Node) -> void:
	var bar = HealthBarScene.instantiate()
	bar.target = character
	add_child(bar)


func remove_bar_for(character: Node) -> void:
	for child in get_children():
		if child is HealthBar and child.target == character:
			child.queue_free()
			return


func create_ap_display_for(character: Node) -> void:
	var ap_display = ActionPointsDisplayScene.instantiate()
	ap_display.target = character
	add_child(ap_display)



func remove_ap_display_for(character: Node) -> void:
	for child in get_children():
		if child is ActionPointsDisplay and child.target == character:
			child.queue_free()
			return


func create_def_display_for(character: Node) -> void:
	var def_display = DefenseDisplayScene.instantiate()
	def_display.target = character
	add_child(def_display)


func remove_def_display_for(character: Node) -> void:
	for child in get_children():
		if child is DefenseDisplay and child.target == character:
			child.queue_free()
			return
