extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func display( text, img, bg):
	#Probably needs work, or be careful how we send info
	$Control/text.text = text
	$Control/sprite.texture = img
	$Control/background.texture = bg
	
	$AnimationPlayer.play("slideIn", -1)
	
func _on_hide_pressed():
	$AnimationPlayer.play("slideOut", -1)