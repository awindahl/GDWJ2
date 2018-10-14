extends Node2D

signal tile_constructed

var tile_pos setget tile_pos_set, tile_pos_get
var adjacent_tile_positions setget , adjacent_tile_positions_get
var Door = preload("res://Tiles/Door.tscn")

var doors = []
var TILE_WIDTH = 512

export(bool) var UpperDoor = false
export(bool) var RightDoor = false
export(bool) var LeftDoor = false
export(bool) var LowerDoor = false

var Grid	# Again we should avoid using parent objects like this in the future - have the grid object do things itself

func _process(delta):
	
	var upper_door = Door.instance()
	var right_hand_door = Door.instance()
	var left_hand_door = Door.instance()
	var lower_door = Door.instance()
	upper_door.door_pos = Vector2(0, -1)
	right_hand_door.door_pos = Vector2(1, 0)
	left_hand_door.door_pos = Vector2(-1, 0)
	lower_door.door_pos = Vector2(0, 1)
	
	if UpperDoor:
		self.add_door(upper_door)
		UpperDoor = int(UpperDoor) - 1
	if RightDoor:
		self.add_door(right_hand_door)
		RightDoor = int(RightDoor) - 1
	if LeftDoor:
		self.add_door(left_hand_door)
		LeftDoor = int(LeftDoor) - 1
	if LowerDoor:
		self.add_door(lower_door)
		LowerDoor = int(LowerDoor) - 1

func add_door(door):
	doors.append(door)
	self.add_child(door)

func remove_door(door):
	doors.remove(doors.find(door))
	self.remove_child(door)

func _ready():
	self.Grid = self.get_parent()
	self.connect("tile_constructed", Grid, "_on_tile_constructed", [self])
	emit_signal("tile_constructed")

func tile_pos_set(new_tile_pos):
	self.position = new_tile_pos*512

func tile_pos_get():
	return self.position/512
	
func adjacent_to(other_tile):
	# 'adjacent' only horizontally and vertically, NOT DIAGONALLY
	return self.tile_pos.distance_to(other_tile.tile_pos) <= 1

func adjacent_tile_positions_get():
	return [self.tile_pos + Vector2(0, 1), self.tile_pos + Vector2(1, 0), self.tile_pos + Vector2(0, -1), self.tile_pos + Vector2(-1, 0)]

func get_facing_doors(tile):
	# Give this function another tile. If there are a pair of doors which are facing each other on these tiles then 
	# the function will return a 2-length array with them inside (DISREGARDING DISTANCE). 
	# Otherwise the function will return an empty array.
	var facing_doors = []
	for my_door in self.doors:
		for other_door in tile.doors:
			if my_door.facing(other_door):
				facing_doors.append(my_door)
				facing_doors.append(other_door)
	return facing_doors
		