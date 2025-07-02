extends Node
class_name BaseCharacter

signal hp_changed(current_hp: int)
signal ap_changed(current_actions: int)
signal def_changed(current_def: int)
signal block_changed(current_block: int)
signal melee_changed(current_melee_atk: int)
signal ranged_changed(current_ranged_atk: int)
#is my turn signal and var

var sprite_path: String
var character_name: String
var max_hp: int
var current_hp: int
var melee_atk: int
var current_melee_atk: int
var ranged_atk: int
var current_ranged_atk: int
var base_def: int
var current_def: int
var base_block: int
var current_block: int
var max_actions: int
var temp_max_actions: int #refactor current_max_actions
var current_actions: int # refactor remaining_actions
var currently_engaged: bool


func set_core_stats(blueprint: Dictionary) -> void:
	sprite_path = blueprint["sprite_path"]
	character_name = blueprint["name"]
	max_hp = blueprint["max_hp"]
	current_hp = max_hp
	melee_atk = blueprint["melee_atk"]
	current_melee_atk = melee_atk
	ranged_atk = blueprint["ranged_atk"]
	current_ranged_atk = ranged_atk
	base_def = blueprint["def"]
	current_def = base_def
	base_block = blueprint["block"]
	current_block = base_block
	max_actions = blueprint["max_actions"]
	temp_max_actions = max_actions
	current_actions = max_actions
	currently_engaged = false


func reset_actions():
	temp_max_actions = max_actions
	current_actions = max_actions
	emit_signal("ap_changed", current_actions)


func use_action():
	current_actions -= 1
	emit_signal("ap_changed", current_actions)


func has_no_actions() -> bool:
	return current_actions == 0


func recieve_damage(damage: int) -> void:
	var damage_blocked = min(current_def, damage)
	var damage_taken = damage - damage_blocked
	current_def -= damage_blocked
	current_def = max(current_def, 0)
	emit_signal("def_changed", current_def)
	current_hp = current_hp - damage_taken
	emit_signal("hp_changed", current_hp)


func engage() -> void:
	currently_engaged = true


func disengage() -> void:
	currently_engaged = false


func attack() -> int:
	var damage: int
	if currently_engaged:
		damage = melee_attack()
	else:
		damage = ranged_attack()
	return damage


func melee_attack() -> int:
	var damage: int = melee_atk
	return damage


func ranged_attack() -> int:
	var damage: int = ranged_atk
	return damage


func defend() -> void:
	current_def = current_def + current_block # when do you use the action? here or in combat manager?
	emit_signal("def_changed", current_def)
	

func reset_def() -> void:
	current_def = base_def
	emit_signal("def_changed", current_def)


func use_item() -> void:
	pass
