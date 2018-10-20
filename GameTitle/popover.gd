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
	$Control/sprite.texture = load(img)
	$Control/background.texture = load(bg)
	
	$AnimationPlayer.play("slideIn", -1)
	$AudioStreamPlayer.play()
	get_parent().get_tree().paused = true
	
func _on_hide_pressed():
	$AnimationPlayer.play("slideOut", -1)
	get_parent().get_tree().paused = false