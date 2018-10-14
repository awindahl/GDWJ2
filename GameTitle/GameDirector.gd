extends Node

var volume = 25
var playing = false
var currentObjective = "Survive. Also press 'Z' to fire off a test popout."
var dict = []

func _ready():
	Engine.set_target_fps(60)
	
	var file = File.new();
	file.open("res://Lists/tiles.json", File.READ)
	var text = file.get_as_text()
	file.close()
	
	dict = JSON.parse(text).result

	print(dict.size(), " tiles loaded.")
	# LOAD ALL THE LISTS INTO ARRAYS IN GODOT


#func _process(delta):
#	HERE BE GAME RELATED THINGS RUNNING
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#	remember to go to Export, 
#	then the resources tab and set the export mode to 
#	Export all resources in the project to 
#	make godot include the JSON file in the build