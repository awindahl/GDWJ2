extends Node2D

var grid_pos setget grid_pos_set, grid_pos_get
var Door = preload("res://Tiles/Door.tscn")

var upper_door = Door.instance()
var right_hand_door = Door.instance()
var left_hand_door = Door.instance()
var lower_door = Door.instance()

func _init():
	upper_door.door_pos = Vector2(0, -1)
	self.add_child(upper_door)
	right_hand_door.rotation = deg2rad(90)
	right_hand_door.door_pos = Vector2(1, 0)
	self.add_child(right_hand_door)
	left_hand_door.rotation = deg2rad(90)
	left_hand_door.door_pos = Vector2(-1, 0)
	self.add_child(left_hand_door)
	lower_door.door_pos = Vector2(0, 1)
	self.add_child(lower_door)
	

func _ready():
	pass

func grid_pos_set(new_grid_pos):
	grid_pos = new_grid_pos
	# Either raise a signal here that the pos has changed and let the Grid deal with it
	# OR change the position of the Tile on the Grid directly

func grid_pos_get():
	return grid_pos
	