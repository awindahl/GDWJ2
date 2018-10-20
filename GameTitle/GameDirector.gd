extends Node

var volume = 25
var playing = false
var currentObjective = "Survive. Also press 'Z' to fire off a test popout."
var sanity = 6
var strength = 5
var strBonus = 0
var sanBonus = 0
var canOpen = false #remember this, this is important
var haunt_counter = 1
var haunting = false

var dict = {}
var evDict = {}
var haDict = {}
var randomNr = 0
var items = []
var events = []

var tempEvent
var tempText
var TempImage
var TempBg

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
	add_user_signal("pop_display")
	add_user_signal("pop_update")
	add_user_signal("change_objective")
	randomize() #RANDOM THE SEED EKIN, RANDOM THE SEEED
	
	# LOAD ALL THE LISTS INTO ARRAYS IN GODOT
	var file = File.new();
	file.open("res://Lists/items.json", File.READ)
	var text = file.get_as_text()
	file.close()
	dict = JSON.parse(text).result
	file.open("res://Lists/events.json", File.READ)
	text = file.get_as_text()
	file.close()
	evDict = JSON.parse(text).result
	file.open("res://Lists/haunts.json", File.READ)
	text = file.get_as_text()
	file.close()
	haDict = JSON.parse(text).result
	
	print(haDict.size(), " haunts loaded.")
	print(evDict.size(), " events loaded.")
	print(dict.size(), " items loaded.")

func get_tiles_left(floor_name):
	var tiles = []
	for tile in self.instanced_tiles:
		if self.tiles_placed.find(tile) == -1:
			match floor_name:
				"Basement":
					if tile.is_basement:
						tiles.append(tile)
				"GroundFloor":
					if tile.is_ground_floor:
						tiles.append(tile)
				"FirstFloor":
					if tile.is_first_floor:
						tiles.append(tile)
	return tiles
	
#	remember to go to Export, 
#	then the resources tab and set the export mode to 
#	Export all resources in the project to 
#	make godot include the JSON file in the build
	
func update_hud():
	emit_signal("hud_update")

func check_game_over():
	if strength < 1 || sanity < 1:
		transition.fade_to("res://gameOver.tscn")

func _process(delta):
	
#	HERE BE GAME RELATED THINGS RUNNING
#	update game timer if game in progress?
	pass

func roll_haunt():
	var roll = randi() % 9
	if roll > haunt_counter:
		haunt_counter = haunt_counter + 1
	else:
		print("haunt happened!")
		activate_haunt()

func activate_haunt():
	haunting = true
	var roll = randi() % 3 + 1
	match roll:
		1:
			currentObjective = haDict["The Dark Ascent"]["objective"]
			#activate the dark ascent
			activate_ascent()
		2:
			currentObjective = haDict["An ancient evil awakens"]["objective"]
			#activate an ancient evil awakens
			activate_ancient_evil()
		3:
			currentObjective = haDict["The Plague"]["objective"]
			#activate the plague
			activate_the_plague()

	emit_signal("change_objective")

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
	check_game_over()
	update_hud()

func activate_event(eName, eStage=0):
	match eName:
		1: haunted_hand(eStage)
		2: creak(eStage)
		3: chill_wind(eStage)
		4: bloody_walls(eStage)
		5: strange_potion(eStage)
		6: unstable_ground(eStage)
		
func haunted_hand(nr):
	match nr:
		0:
			tempText = evDict["The haunted hand"]["desc"]
			tempEvent = 1
			emit_signal("pop_display")
		1:
			var num = randi() % ((strength+strBonus)*3)
			if num > 6:
				strength = strength + 1
				tempText = evDict["The haunted hand"]["desc"] + " \n\n You manage to control your own hand through strength alone, gained 1 strength."
			elif num > 3:
				tempText = evDict["The haunted hand"]["desc"] + " \n\n You wrestle yourself free and regain control over your hand."
			elif num > 1:
				strength = strength - 1
				tempText = evDict["The haunted hand"]["desc"] + " \n\n Your hand overpowers you and smacks you into the wall, after hitting your head your hand returns back to normal. Lost 1 strength."
			elif num == 0:
				strength = strength - 1
				sanity = sanity - 1
				tempText = evDict["The haunted hand"]["desc"] + " \n\n In your desperation you try to hack off your own hand. Took 1 strength and 1 sanity damage."
			emit_signal("pop_update")
			update_hud()

func creak(nr):
	match nr:
		0:
			tempText = evDict["A creak, a crack!"]["desc"]
			tempEvent = 2
			emit_signal("pop_display")
		1:
			var num = randi() % ((sanity+sanBonus)*3)
			if num > 6:
				sanity = sanity + 1
				tempText = evDict["A creak, a crack!"]["desc"] + " \n\n You sigh in relief. Gained 1 sanity."
			elif num > 2:
				tempText = evDict["A creak, a crack!"]["desc"] + " \n\n You're easily spooked, but nothing bad happens."
			elif num < 2:
				sanity = sanity - 1
				tempText = evDict["A creak, a crack!"]["desc"] + " \n\n This was the last thing you needed. Lost 1 sanity."
			emit_signal("pop_update")
			update_hud()
	
func chill_wind(nr):
	match nr:
		0:
			tempText = evDict["A chill wind blows"]["desc"]
			tempEvent = 3
			emit_signal("pop_display")
		1:
			var num = randi() % ((sanity+sanBonus)*3)
			if num > 5:
				sanity = sanity + 1
				tempText = evDict["A chill wind blows"]["desc"] + " \n\n Everything around you seems fine, your head hurts a bit but other than that you're fine."
			elif num > 2:
				tempText = evDict["A chill wind blows"]["desc"] + " \n\n You fell straight ahead and hurt your nose badly. The blood has dried but you're still reeling from the pain. Lost 1 strength."
			elif num < 2:
				tempText = evDict["A chill wind blows"]["desc"] + " \n\n During your fall ghostly images filled your mind. Every time you close your eyes you see the face of a screaming woman right infront of you. Lost 1 sanity."
			emit_signal("pop_update")
			update_hud()
	
func bloody_walls(nr):
	match nr:
		0:
			tempText = evDict["Bloody Walls"]["desc"]
			tempEvent = 4
			emit_signal("pop_display")
		1:
			var num = randi() % ((sanity+sanBonus)*3)
			var num2 = randi() % ((strength+strBonus)*3)
			if num > num2:
				sanity = sanity + 1
				strength = strength - 1
				tempText = evDict["Bloody Walls"]["desc"] + " \n\n You strengthen your resolve! Gained 1 sanity, but lost 1 strength"
			elif num <= num2:
				sanity = sanity - 1
				strength = strength + 1
				tempText = evDict["Bloody Walls"]["desc"] + " \n\n You can't believe this is happening to you, but you prepare for the worst. Gained 1 strength, but lost 1 sanity"
			emit_signal("pop_update")
			update_hud()
			roll_haunt()
	
func strange_potion(nr):
	match nr:
		0:
			tempText = evDict["Strange Potion"]["desc"]
			tempEvent = 5
			emit_signal("pop_display")
		1:
			var num = randi() % ((strength+strBonus)*3)
			if num > 5:
				strength = strength + 2
				sanity = sanity + 1
				tempText = evDict["Strange Potion"]["desc"] + " \n\n The drink tastes like blood. But there is something special about this blood. Gained 2 strength and 1 sanity."
			elif num > 3:
				strength = strength + 1
				tempText = evDict["Strange Potion"]["desc"] + " \n\n The drink is spiked with something, you feel yourself growing stronger. Gained 1 strength."
			elif num > 1:
				tempText = evDict["Strange Potion"]["desc"] + " \n\n Nothing happens, it's just water."
			elif num < 1:
				strength = strength - 1
				tempText = evDict["Strange Potion"]["desc"] + " \n\n The potion must have gone bad! You feel how your strength slowly leaves your body. Lost 1 strength."
			emit_signal("pop_update")
			update_hud()
			roll_haunt()
	
func unstable_ground(nr):
	match nr:
		0:
			tempText = evDict["Unstable ground"]["desc"]
			tempEvent = 6
			emit_signal("pop_display")
		1:
			var num = randi() % ((strength+strBonus)*3)
			if num > 5:
				tempText = evDict["Unstable ground"]["desc"] + " \n\n The planks give way. Lose 1 strength."
			elif num > 2:
				tempText = evDict["Unstable ground"]["desc"] + " \n\n To your relief nothing happens."
			elif num < 2:
				sanity = sanity + 1
				tempText = evDict["Unstable ground"]["desc"] + " \n\n Carefully moving through the room, you avoid the old rotten planks. Gained 1 sanity."
			emit_signal("pop_update")
			update_hud()
			roll_haunt()

func activate_ascent():
	pass

func activate_ancient_evil():
	pass
	
func activate_the_plague():
	pass