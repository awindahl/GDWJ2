extends Node

var volume = 25
var playing = false
var currentObjective = "Survive. Also press 'Z' to fire off a test popout."
var dict = {}
var randomNr = 0


func _ready():
	Engine.set_target_fps(60)
	randomize() #RANDOM THE SEED EKIN, RANDOM THE SEEED
	
	# LOAD ALL THE LISTS INTO ARRAYS IN GODOT
	var file = File.new();
	file.open("res://Lists/items.json", File.READ)
	var text = file.get_as_text()
	file.close()
	dict = JSON.parse(text).result
	print(dict.size(), " items loaded.")

#	remember to go to Export, 
#	then the resources tab and set the export mode to 
#	Export all resources in the project to 
#	make godot include the JSON file in the build


#func _process(delta):
#	HERE BE GAME RELATED THINGS RUNNING
#	update game timer if game in progress



#	Game win conditions and effect here