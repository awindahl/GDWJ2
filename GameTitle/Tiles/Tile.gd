extends Node2D

var grid_pos setget grid_pos_set, grid_pos_get

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func grid_pos_set(new_grid_pos):
	grid_pos = new_grid_pos
	# Either raise a signal here that the pos has changed and let the Grid deal with it
	# OR change the position of the Tile on the Grid directly

func grid_pos_get():
	return grid_pos
	