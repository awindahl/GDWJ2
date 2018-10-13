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
	upper_landing.grid_pos = [0,0]
	self.add_tile(upper_landing)
	

func _on_door_opened(door):
	print("A door has been opened!")
	print(door)
