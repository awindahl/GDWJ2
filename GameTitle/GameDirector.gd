extends Node

var volume = 25
var playing = false
var currentObjective = "Survive. Also press 'Z' to fire off a test popout."
var sanity = 6
var strength = 5
var strBonus = 0
var sanBonus = 0
var canOpen = false

var dict = {}
var randomNr = 0
var items = []
var events = []

var BasicTile = preload("res://Tiles/BasicTile.tscn")
var HallwayTile = preload("res://Tiles/HallwayTile.tscn")
var CrossingTile = preload("res://Tiles/CrossingTile.tscn")
var BallroomTile = preload("res://Tiles/BallroomTile.tscn")
var KitchenTile = preload("res://Tiles/KitchenTile.tscn")
var StorageTile = preload("res://Tiles/StorageTile.tscn")
var BedroomTile = preload("res://Tiles/BedroomTile.tscn")
var StairwayTile = preload("res://Tiles/StairwayTile.tscn")
var DiningroomTile = preload("res://Tiles/DiningroomTile.tscn")
var LaundromatTile = preload("res://Tiles/LaundromatTile.tscn")
var OldpassageTile = preload("res://Tiles/OldpassageTile.tscn")
var WinecellarTile = preload("res://Tiles/WinecellarTile.tscn")
var ChapeTile = preload("res://Tiles/ChapelTile.tscn")
var ArtgalleryTile = preload("res://Tiles/ArtgalleryTile.tscn")
var GuestbedroomTile = preload("res://Tiles/GuestbedroomTile.tscn")
var TreasuryTile = preload("res://Tiles/TreasuryTile.tscn")
var ClosetTile = preload("res://Tiles/ClosetTile.tscn")
var WashroomTile = preload("res://Tiles/WashroomTile.tscn")
var OldroomTile = preload("res://Tiles/OldroomTile.tscn")
var MainroomTile = preload("res://Tiles/MainhallTile.tscn")
var RoundhallTile = preload("res://Tiles/RoundhallTile.tscn")
var ThreewaycrossTile = preload("res://Tiles/ThreewaycrossTile.tscn")

var tile_list = [BasicTile, HallwayTile, CrossingTile, BallroomTile, KitchenTile, StorageTile, BedroomTile,
		StairwayTile, DiningroomTile, LaundromatTile, OldpassageTile, WinecellarTile, ChapeTile, ArtgalleryTile,
		GuestbedroomTile, TreasuryTile, ClosetTile, WashroomTile, OldroomTile, MainroomTile, RoundhallTile, ThreewaycrossTile]
var instanced_tiles = []

export(Array) var tiles_placed

func _ready():
	for tile in tile_list:
		self.instanced_tiles.append(tile.instance())
	
	self.tiles_placed = []
	Engine.set_target_fps(60)
	add_user_signal("hud_update")
	randomize() #RANDOM THE SEED EKIN, RANDOM THE SEEEEEEEEEEEEEEEEEED
	
	# LOAD ALL THE LISTS INTO ARRAYS IN GODOT
	var file = File.new();
	file.open("res://Lists/items.json", File.READ)
	var text = file.get_as_text()
	file.close()
	dict = JSON.parse(text).result
	print(dict.size(), " items loaded.")

func get_tiles_left(floor_name):
	var tiles = []
	for tile in self.instanced_tiles:
		if self.tiles_placed.find(tile) == -1:
			match floor_name:
				"basement":
					if tile.is_basement:
						tiles.append(tile)
				"ground_floor":
					if tile.is_ground_floor:
						tiles.append(tile)
				"first_floor":
					if tile.is_first_floor:
						tiles.append(tile)
	return tiles
	
#	remember to go to Export, 
#	then the resources tab and set the export mode to 
#	Export all resources in the project to 
#	make godot include the JSON file in the build


func _process(delta):
	
#	HERE BE GAME RELATED THINGS RUNNING
#	update game timer if game in progress?
	pass


#	Game win conditions and effect here
func activate_rule(iName):
	print("activating " + dict[iName]["effectNr"])
	match int(dict[iName]["effectNr"]):
		1: 
			strBonus = strBonus + 2
		2: 
			var num = randi() % 18 + 1
			if num > 12:
				strength = strength + 1
				sanity = sanity + 1
			elif num > 6:
				sanBonus = sanBonus + 1
				strBonus = strBonus + 1
			elif num > 3:
				#trigger random event
				pass
			else:
				strength = 1
				sanity = 1
		3: 
			strength = strength + 1
		4: 
			sanity = sanity + 1
			strength = strength - 1
		5: 
			sanBonus = sanBonus + 1
		6:
			sanBonus = sanBonus - 1
			strBonus = strBonus + 1
		7:
			sanBonus = sanBonus + 2
		8:
			var num = randi() % 6 + 1 + sanBonus
			if num > 5:
				sanBonus = sanBonus + 2
			elif num > 3:
				pass
			else:
				sanBonus = 0
		9:
			sanity = sanity + 1
			canOpen = true
	print("sanity: " + str(sanity) +", strength: " + str(strength) + ", sanity bonus: " + str(sanBonus) + ", strength bonus: " + str(strBonus))
	update_hud()
	
func update_hud():
	emit_signal("hud_update")
	
func activate_event(eName):
	pass