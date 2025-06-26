extends Control

func _ready():
	pass


func _on_start_button_pressed():
	SceneManager.change_ui("res://scenes/ui/MainMenu.tscn")
