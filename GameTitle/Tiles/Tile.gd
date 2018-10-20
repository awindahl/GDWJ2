extends Node2D

signal moved

const TYPE = "TILE"
var tile_pos setget tile_pos_set, tile_pos_get
var adjacent_tile_positions setget , adjacent_tile_positions_get
var Door = preload("res://Tiles/Door.tscn")

var doors
var TILE_WIDTH = 512

func _ready():
	self.doors = []
	self.doors.append(self.get_node("Upper Door"))
	self.doors.append(self.get_node("Right Hand Door"))
	self.doors.append(self.get_node("Lower Door"))
	self.doors.append(self.get_node("Left Hand Door"))

func tile_pos_set(new_tile_pos):
	self.position = (new_tile_pos*512).round()
	emit_signal("moved", self)

func tile_pos_get():
	return (self.position/512).round()

func find_door(pos):
	for door in self.doors:
		if door.door_pos_rel == pos:
			return door
	return null
	
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
			if my_door.points_to_tile(tile) && other_door.points_to_tile(self):
				facing_doors.append(my_door)
				facing_doors.append(other_door)
				break
	return facing_doors
	
func number_of_open_doors(tile):
	# Returns the number of doors which are open
	var open_doors = 0
	for door in self.doors:
		open_doors += door.is_open
	return open_doors
	
func rotate_clockwise():
	self.rotation = self.rotation + Vector2(0, 1).angle()
	
func rotate_anticlockwise():
	self.rotation = self.rotation + Vector2(0, -1).angle()