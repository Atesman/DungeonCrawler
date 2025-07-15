extends Node

@export var effect_ref: Node

@onready var texture_rect = $HBoxContainer/TextureRect
@onready var label = $HBoxContainer/Label


func _ready() -> void:
	_set_texture()
	_set_label()
	connect_signals()
	

func _set_texture():
	var texture_path = "res://assets/icons/%s_icon.png" % effect_ref.ability_name
	var new_texture = load(texture_path)
	if new_texture:
		texture_rect.texture = new_texture


func _set_label():
	var label_text = "%d" % effect_ref.display_value
	label.text = label_text


func _update_label(new_display_value: int):
	var label_text = "%d" % effect_ref.display_value
	label.text = label_text


func connect_signals():
	effect_ref.connect("display_value_updated", Callable(self, "_update_label"))


#func update_label():
