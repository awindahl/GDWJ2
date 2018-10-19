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

var tile_list = [HallwayTile, BasicTile, CrossingTile, BallroomTile, KitchenTile, StorageTile, BedroomTile,
		StairwayTile, DiningroomTile, LaundromatTile, OldpassageTile]

var tiles

func _init():
	self.tiles = []

func _ready():
	# Register all pre-instanced Tiles to the
	for child in self.get_children():
		if child.TYPE == "TILE":
			self.tiles.append(child)
			self._on_tile_constructed(child)	# Need this here because _ready() happens after tiles are constructed

func add_tile(tile):
	self.tiles.append(tile)
	self.add_child(tile)

func remove_tile(tile):
	self.tiles.remove(tiles.find(tile))
	self.remove_child(tile)

func _on_tile_constructed(tile):
	# If a tile is constructed then find all adjacent Tiles and open doors if they are connected
	var adjacent_tiles = []
	for other_tile in self.tiles:
		if tile != other_tile && tile.adjacent_to(other_tile):
			adjacent_tiles.append(other_tile)

	for adjacent_tile in adjacent_tiles:
		var facing_doors = tile.get_facing_doors(adjacent_tile)
		if facing_doors:
			for door in facing_doors:
				if door.is_visible_in_tree():
					door.open()

func find_tile_from_pos(position):
	for tile in self.tiles:
		if tile.tile_pos == position:
			return tile
	return null

func _on_player_requesting_door_to_open(door):
	if self.find_tile_from_pos(door.next_tile_pos):
		print("Can't add a room here - already a room next door!")
		return

	if !door.is_visible_in_tree():
		print("Shhh I'm a door but I don't really exist! Can't open me ;)")
		return

	var new_tile = self.tile_list[randi() %  self.tile_list.size()].instance()
	new_tile.tile_pos = door.next_tile_pos
	new_tile.global_rotation = door.door_pos_rel.angle() + Vector2(0, 1).angle()	# Not certain about this but hey-ho
	self.add_tile(new_tile)
