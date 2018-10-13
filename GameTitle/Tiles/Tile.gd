extends Node2D

var tile_pos setget tile_pos_set, tile_pos_get
var Door = preload("res://Tiles/Door.tscn")
var TILE_WIDTH = 512

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

func tile_pos_set(new_tile_pos):
	self.position = new_tile_pos*512

func tile_pos_get():
	return self.position/512
	