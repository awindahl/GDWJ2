extends Node

var ev = false
var evNr = 0

func _ready():
	GameDirector.connect("pop_display", self, "temp_display")
	GameDirector.connect("pop_update", self, "temp_update_display")

func display( text, img, bg, event=0):
	#Probably needs work, or be careful how we send info
	$Control/text.text = text
	$Control/sprite.texture = load(img)
	$Control/background.texture = load(bg)
	if event>0:
		ev = true
		$Control/hide.text = "Next"
		
	$AnimationPlayer.play("slideIn", -1)
	$AudioStreamPlayer.play()
	get_parent().get_tree().paused = true
	
func update_display( text, img="", bg=""):
	$Control/text.text = text
	if !img == "":
		$Control/sprite.texture = load(img)
	if !bg == "":
		$Control/background.texture = load(bg)
	ev = false
	$Control/hide.text = "Hide"
	
func _on_hide_pressed():
	if ev:
		GameDirector.activate_event(evNr, 1)
	else:
		$AnimationPlayer.play("slideOut", -1)
		get_parent().get_tree().paused = false
		GameDirector.check_game_over()
		
func temp_displayer():
	#also fetch the right assets, but later
	display(GameDirector.tempText, "res://Asset Lib/Art/mute_btn_active.png", "res://Asset Lib/Art/popoverbg.png", GameDirector.tempEvent)
	
func temp_update_display():
	update_display(GameDirector.tempText)