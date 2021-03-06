extends Node

var ev = false
var evNr
var evSt = 0
onready var gamedirector = get_node("/root/GameDirector")

func _ready():
	GameDirector.connect("pop_display", self, "temp_displayer")
	GameDirector.connect("pop_update", self, "temp_update_display")
	GameDirector.connect("pop_haunt_display", self, "temp_haunt_displayer")

func display( text, img="", bg="", event=0):
	#Probably needs work, or be careful how we send info
	if !img == "":
		$Control/sprite.texture = load(img)
	if !bg == "":
		$Control/background.texture = load(bg)
	$Control/text.bbcode_text = text
	$Control/sprite.texture = load(img)
	$Control/background.texture = load(bg)
	if event>0:
		ev = true
		evNr = event
		$Control/hide.text = "Next"
		
	$AnimationPlayer.play("slideIn", -1)
	$AudioStreamPlayer.play()
	get_parent().get_parent().get_node("Walking").stop()
	get_parent().get_tree().paused = true
	
func update_display( text, img="", bg=""):
	$Control/text.bbcode_text = text
	if !img == "":
		$Control/sprite.texture = load(img)
	if !bg == "":
		$Control/background.texture = load(bg)
	ev = false
	evSt = 0
	$Control/hide.text = "Hide"
	
func _on_hide_pressed():
	if ev:
		evSt += 1
		GameDirector.activate_event(evNr, evSt)
	else:
		$AnimationPlayer.play("slideOut", -1)
		get_parent().get_tree().paused = false
		GameDirector.check_game_over()
		
func temp_displayer():
	#also fetch the right assets, but later
	display(GameDirector.tempText, "res://Asset Lib/Art/mute_btn_active.png", "res://Asset Lib/Art/popoverbg.png", GameDirector.tempEvent)
	
func temp_update_display():
	update_display(GameDirector.tempText)
	
func temp_haunt_displayer():
	#Insert spooky background here instead
	display(GameDirector.tempText, "res://Asset Lib/Art/mute_btn_active.png", "res://Asset Lib/Art/popoverbg.png", GameDirector.tempEvent)