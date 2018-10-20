extends Node2D

var upper_landing
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

var tile_list = [HallwayTile, BasicTile, CrossingTile, BallroomTile, KitchenTile, StorageTile, BedroomTile,
		StairwayTile, DiningroomTile, LaundromatTile, OldpassageTile, WinecellarTile, ChapeTile, ArtgalleryTile,
		GuestbedroomTile, TreasuryTile, ClosetTile, WashroomTile, OldroomTile, MainroomTile, RoundhallTile, ThreewaycrossTile]

var tiles

func _init():
	self.tiles = []

func _ready():
	for child in self.get_children():
		if child.get("TYPE") == "TILE":
			self.tiles.append(child)
		#	self._on_tile_constructed(child) # Need this here because _ready() happens after tiles are constructed
		
func add_tile(tile):
	self.add_child(tile)
	self.register_tile(tile)

func register_tile(tile):
	tile.connect("moved", self, "_on_Tile_moved")
	self.tiles.append(tile)

func remove_tile(tile):
	self.tiles.remove(tiles.find(tile))
	self.remove_child(tile)
	
func find_tile(pos):
	for tile in self.tiles:
		if tile.tile_pos == pos:
			return tile
	return null

func get_adjacent_tiles(tile):
	var adjacent_tiles = []
	for tile_pos in tile.adjacent_tile_positions:
		var other_tile = find_tile(tile_pos)
		if other_tile:
			adjacent_tiles.append(other_tile)
	return adjacent_tiles

# Signal callbacks
func _on_Tile_moved(tile):
	# If a tile is moved then find all adjacent Tiles and open doors if they are connected. Else, close them.
	for door in tile.doors:
		var adjacent_tile = self.find_tile(door.next_tile_pos)
		if adjacent_tile:
			var opposite_door = adjacent_tile.find_door(door.opposite_door_pos_rel)
			if opposite_door:
				door.open()
				opposite_door.open()
			else:
				door.close()
		else:
			door.close()
	
func _on_Player_requesting_door_to_open(door):
	if self.find_tile(door.next_tile_pos):
		print("Can't add a room here - already a room next door!")
		return

	if !door.is_visible_in_tree():
		print("Shhh I'm a door but I don't really exist! Can't open me ;)")
		return

	var new_tile = self.tile_list[randi() %  self.tile_list.size()].instance()
	self.add_tile(new_tile)
	new_tile.tile_pos = door.next_tile_pos	# Delet dis
	
	# Algorithm for choosing rotation here
	# Ensure three rules are satisfied:
	# 1) Door being opened is connected
	# 2) Number of total connections is maximised
	# 3) When there's a tie, randomise the solutions
	# new_tile.global_rotation = door.door_pos_rel.angle() + Vector2(0, 1).angle()	# Not certain about this but hey-ho
	var possible_rotations = []
	
	# Simulate doors
	for i in range(4):
		var opposite_door = new_tile.find_door(door.opposite_door_pos_rel)
		if !opposite_door.is_wall:
			possible_rotations.append([new_tile.global_rotation, self.connected_doors(new_tile).size()])
		# That's Numberwang! Rotate the board!
		new_tile.rotate_clockwise()
	
	# Find max connection number of these entries
	var max_connections = 0
	for possible_rotation in possible_rotations:
		max_connections = max(max_connections, possible_rotation[1])
	
	var good_rotations = []
	for possible_rotation in possible_rotations:
		if max_connections == possible_rotation[1]:
			good_rotations.append(possible_rotation[0])
			
	# Choose a random selection from the good_rotations
	new_tile.global_rotation = good_rotations[randi() %  good_rotations.size()]
	self._on_Tile_moved(new_tile)	# Do this manually for the time being
	
func connected_doors(tile):
	# This function returns all of the doors which are adjacent to a tile. "Connected" in this sense means if the door is not a wall instead
	var connected_doors = []
	for door in tile.doors:
		var other_tile = self.find_tile(door.next_tile_pos)
		if other_tile:
			for other_door in other_tile.doors:
				if other_door.is_visible_in_tree() && door.is_visible_in_tree() && other_door.opposite_to_door(door):
					connected_doors.append(door)
	return connected_doors
