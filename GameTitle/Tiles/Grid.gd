extends Node2D

var upper_landing
var BaseTile = preload("res://Tiles/Tile.tscn")
var tiles = []

func add_tile(tile):
	tiles.append(tile)
	self.add_child(tile)

func remove_tile(tile):
	tiles.remove(tiles.find(tile))
	self.remove_child(tile)

func _ready():
	# Called when the node is added to the scene for the first time.
	upper_landing = BaseTile.instance()
	# Initialization here, unfortunately
	upper_landing.tile_pos = Vector2(0, 0)
	self.add_tile(upper_landing)

func _on_door_opened(door):
	var new_tile = BaseTile.instance()
	new_tile.tile_pos = door.Tile.tile_pos + door.door_pos_rel
	self.add_tile(new_tile)
	
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
