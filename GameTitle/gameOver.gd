extends Control

onready var gamedirector = get_node("/root/GameDirector")

func _ready():
	get_tree().paused = false

func _on_Button_pressed():
	GameDirector.reset()
	transition.fade_to("res://menu.tscn")