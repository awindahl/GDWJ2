extends Node2D

signal tile_constructed

const TYPE = "TILE"
var tile_pos setget tile_pos_set, tile_pos_get
var adjacent_tile_positions setget , adjacent_tile_positions_get
var Door = preload("res://Tiles/Door.tscn")

var doors
var TILE_WIDTH = 512

var Floor	# Again we should avoid using parent objects like this in the future - have the Floor object do things itself

func _ready():
	self.doors = []
	for door in self.get_children():
		if door.is_visible_in_tree() && door.get("TYPE") == "DOOR":
			self.doors.append(door)
			
#	self.doors.append(self.get_node("Upper Door"))
#	self.doors.append(self.get_node("Right Hand Door"))
#	self.doors.append(self.get_node("Lower Door"))
#	self.doors.append(self.get_node("Left Hand Door"))

	self.Floor = self.get_parent()
	self.connect("tile_constructed", Floor, "_on_tile_constructed", [self])
	emit_signal("tile_constructed")

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
			if other_door.TYPE == "DOOR" && other_door.is_visible_in_tree() && my_door.TYPE == "DOOR" && my_door.is_visible_in_tree():
				if my_door.points_to(tile) && other_door.points_to(self):
					facing_doors.append(my_door)
					facing_doors.append(other_door)
					break
	return facing_doors
