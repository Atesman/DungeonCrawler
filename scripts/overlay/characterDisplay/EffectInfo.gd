extends Node

@export var effect_ref: Node

@onready var texture_rect = $HBoxContainer/TextureRect
@onready var label = $HBoxContainer/Label


func _ready() -> void:
	#connect some signals?
	set_texture()
	set_label()
	

func set_texture():
	var texture_path = "res://assets/sprites/%s_icon.png" % effect_ref.ability_name
	var new_texture = load(texture_path)
	if new_texture:
		texture_rect.texture = new_texture


func set_label():
	var label_text = "%d" % effect_ref.display_value
	label.text = label_text