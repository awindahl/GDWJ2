extends Node2D


var upper_landing
var BasicTile = preload("res://Tiles/BasicTile.tscn")
var HallwayTile = preload("res://Tiles/HallwayTile.tscn")
var tile_list = [HallwayTile, BasicTile]
var tiles = []

func add_tile(tile):
	self.tiles.append(tile)
	self.add_child(tile)

func remove_tile(tile):
	self.tiles.remove(tiles.find(tile))
	self.remove_child(tile)

func _ready():
	# Called when the node is added to the scene for the first time.
	upper_landing = BasicTile.instance()
	# Initialization here, unfortunately
	upper_landing.tile_pos = Vector2(0, 0)
	self.add_tile(upper_landing)
	
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
				door.open()

func find_tile_from_pos(position):
	for tile in self.tiles:
		if tile.tile_pos == position:
			return tile
	return null

func _on_player_requesting_door_to_open(door):
	if self.find_tile_from_pos(door.next_tile_pos):
		print("Can't add a door here - already a room next door!")
		return
	var new_tile = self.tile_list[randi() %  self.tile_list.size()].instance()
	new_tile.tile_pos = door.next_tile_pos
	new_tile.global_rotation = door.door_pos_rel.angle() + Vector2(0, 1).angle()	# Not certain about this but hey-ho
	self.add_tile(new_tile)
