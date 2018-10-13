extends Node2D

var upper_landing
var BaseTile = preload("res://Tiles/Tile.tscn")

func add_tile(tile):
	tile.add_to_group('tiles')
	self.add_child(tile)

func remove_tile(tile):
	tile.remove_from_group('tiles')
	self.remove_child(tile)

func _ready():
	# Called when the node is added to the scene for the first time.
	upper_landing = BaseTile.instance()
	# Initialization here, unfortunately
	upper_landing.tile_pos = Vector2(0, 0)
	self.add_tile(upper_landing)
	

func _on_door_opened(door):
	print("A door has been opened! Let's make instantiate a new Tile object")
	var tile_with_door = door.get_parent()
	var new_tile = BaseTile.instance()
	new_tile.tile_pos = tile_with_door.tile_pos + door.door_pos
	self.add_tile(new_tile)
