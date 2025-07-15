extends Node
class_name BaseCharacter

const EffectsManager = preload("res://scripts/characters/EffectsManager.gd")

signal hp_changed(current_hp: int)
signal ap_changed(current_actions: int)
signal def_changed(current_def: int)
signal block_changed(current_block: int)
signal melee_changed(current_melee_atk: int)
signal ranged_changed(current_ranged_atk: int)
signal bonus_damage_changed(bonus_damage: int)
signal health_damaged(target: BaseCharacter, amount: int)
#is my turn signal and var

var effects_manager: EffectsManager = null

# Basic Info
var sprite_path: String
var character_name: String
# HP
var max_hp: int
var current_hp: int
# Attack
var melee_atk: int
var current_melee_atk: int
var ranged_atk: int
var current_ranged_atk: int
var bonus_damage: int
# Defense
var base_def: int
var current_def: int
var base_block: int
var current_block: int
# Actions
var max_actions: int
var temp_max_actions: int #refactor current_max_actions
var current_actions: int # refactor remaining_actions
# Misc
var currently_engaged: bool


func _init(blueprint: Dictionary) -> void:
	set_core_stats(blueprint)


func _ready():
	if effects_manager != null:
		return
	effects_manager = EffectsManager.new()
	add_child(effects_manager)


func set_core_stats(blueprint: Dictionary) -> void:
	sprite_path = blueprint["sprite_path"]
	character_name = blueprint["name"]
	max_hp = blueprint["max_hp"]
	current_hp = max_hp
	melee_atk = blueprint["melee_atk"]
	current_melee_atk = melee_atk
	ranged_atk = blueprint["ranged_atk"]
	current_ranged_atk = ranged_atk
	bonus_damage = 0
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


func deal_damage_to(target: Node, amount: int) -> void:
	var changed = target.recieve_damage(amount)
	if changed:
		emit_signal("health_damaged", target, amount)


func recieve_damage(damage: int) -> bool:
	var damage_blocked = min(current_def, damage)
	var damage_taken = damage - damage_blocked
	current_def -= damage_blocked
	current_def = max(current_def, 0)
	emit_signal("def_changed", current_def)
	if damage_taken > 0:
		current_hp = current_hp - damage_taken
		emit_signal("hp_changed", current_hp)
		if current_hp <= 0:
			EventBus.emit_signal("character_died", self)
		return true
	return false


func lose_health(amount: int):
	current_hp = (current_hp - amount)
	emit_signal("hp_changed", current_hp)
	if current_hp <= 0:
		EventBus.emit_signal("character_died", self)


func engage() -> void:
	currently_engaged = true


func disengage() -> void:
	currently_engaged = false


func attack(melee_range: bool) -> int:
	var damage: int
	if melee_range:
		damage = (melee_attack() + bonus_damage)
	else:
		damage = (ranged_attack() + bonus_damage)
	return damage


func melee_attack() -> int:
	var damage: int = melee_atk
	return damage


func ranged_attack() -> int:
	var damage: int = ranged_atk
	return damage


func adjust_bonus_damage(amount: int):
	bonus_damage = (bonus_damage + amount)
	emit_signal("bonus_damage_changed", bonus_damage)


func defend() -> void:
	current_def = current_def + current_block
	emit_signal("def_changed", current_def)
	

func reset_def() -> void:
	current_def = base_def
	emit_signal("def_changed", current_def)


func use_item() -> void:
	pass
