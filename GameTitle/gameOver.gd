extends Control

func _on_Button_pressed():
	GameDirector.reset()
	transition.fade_to("res://menu.tscn")