extends Node2D

signal tile_constructed

var tile_pos setget tile_pos_set, tile_pos_get
var adjacent_tile_positions setget , adjacent_tile_positions_get
var Door = preload("res://Tiles/Door.tscn")

var doors
var TILE_WIDTH = 512

export(bool) var upper_door setget upper_door_set, upper_door_get
export(bool) var right_hand_door setget right_hand_door_set, right_hand_door_get
export(bool) var lower_door setget lower_door_set, lower_door_get
export(bool) var left_hand_door setget left_hand_door_set, left_hand_door_get

var upper_door_instance
var right_hand_door_instance
var lower_door_instance
var left_hand_door_instance

var Grid	# Again we should avoid using parent objects like this in the future - have the grid object do things itself

func _init():
	self.doors = []

func _ready():
	
	self.Grid = self.get_parent()
	self.connect("tile_constructed", Grid, "_on_tile_constructed", [self])
	emit_signal("tile_constructed")

# WARNING WARNING GABAGE CODE AHEAD. 
# I had to copy and paste the below right now, need something better.

func upper_door_set(new_bool):
	if !self.upper_door && new_bool:
		self.upper_door_instance = Door.instance()
		self.upper_door_instance.door_pos = Vector2(0, -1)
		self.add_door(self.upper_door_instance)
	elif self.upper_door && !new_bool:
		self.upper_door_instance.queue_free()
	
func upper_door_get(new_bool):
	return self.upper_door_instance != null
	
func right_hand_door_set(new_bool):
	if !self.right_hand_door && new_bool:
		self.right_hand_door_instance = Door.instance()
		self.right_hand_door_instance.door_pos = Vector2(1, 0)
		self.add_door(self.right_hand_door_instance)
	elif self.right_hand_door && !new_bool:
		self.right_hand_door_instance.queue_free()
	
func right_hand_door_get(new_bool):
	return self.right_hand_door_instance != null
	
func lower_door_set(new_bool):
	if !self.lower_door && new_bool:
		self.lower_door_instance = Door.instance()
		self.lower_door_instance.door_pos = Vector2(0, 1)
		self.add_door(self.lower_door_instance)
	elif self.lower_door && !new_bool:
		self.lower_door_instance.queue_free()
	
func lower_door_get(new_bool):
	return self.lower_door_instance != null
	
func left_hand_door_set(new_bool):
	if !self.left_hand_door && new_bool:
		self.left_hand_door_instance = Door.instance()
		self.left_hand_door_instance.door_pos = Vector2(-1, 0)
		self.add_door(self.left_hand_door_instance)
	elif self.left_hand_door && !new_bool:
		self.left_hand_door_instance.queue_free()
	
func left_hand_door_get(new_bool):
	return self.left_hand_door_instance != null

func add_door(door):
	self.doors.append(door)
	self.add_child(door)

func remove_door(door):
	self.doors.remove(doors.find(door))
	self.remove_child(door)

func tile_pos_set(new_tile_pos):
	self.position = (new_tile_pos*512).round()

func tile_pos_get():
	return (self.position/512).round()
	
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
			if other_door.get("TYPE") == "DOOR" and my_door.get("TYPE") == "DOOR":
				if my_door.points_to(tile) && other_door.points_to(self):
					facing_doors.append(my_door)
					facing_doors.append(other_door)
					break
	return facing_doors
