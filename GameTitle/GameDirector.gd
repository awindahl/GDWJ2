extends Node

var volume = 25
var playing = false
var currentObjective = "Survive. Also press 'Z' to fire off a test popout."

func _ready():
	Engine.set_target_fps(60)
	print("Loading tile images...")
	var file = File.new();
	file.open("res://Lists/tiles.json", File.READ)
	var text = file.get_as_text()
	file.close()
	
	var all_tiles_dict = JSON.parse(text).result
	for tile_name_key in all_tiles_dict:
		var tile_dict = all_tiles_dict[tile_name_key]
		tile_dict['image'] = load("res://Tiles/" + tile_dict["sprite"])
	print(all_tiles_dict.size(), " tiles loaded.")
	

#func _process(delta):
#	HERE BE GAME RELATED THINGS RUNNING
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

#	remember to go to Export, 
#	then the resources tab and set the export mode to 
#	Export all resources in the project to 
#	make godot include the JSON file in the build