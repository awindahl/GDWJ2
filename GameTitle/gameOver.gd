extends Control

func _ready():
	get_tree().paused = false

func _on_Button_pressed():
	GameDirector.reset()
	transition.fade_to("res://menu.tscn")