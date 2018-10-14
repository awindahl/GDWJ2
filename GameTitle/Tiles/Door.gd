extends Node2D

signal door_opened(door)
var door_pos setget door_pos_set, door_pos_get
var door_pos_rel setget , door_pos_rel_get
var radius = 208

var Tile	# Shouldn't rely on having Tile and Grid too much otherwise could be problems in the future (2-way comms)
var Grid

func _ready():
	self.Tile = self.get_parent()
	self.Grid = self.Tile.get_parent()
	self.connect("door_opened", Grid, "_on_door_opened", [self])

func open():
	self.hide()
	self.get_node('DoorCollisionShape').disabled = true
	# Notify door opened
	self.emit_signal("door_opened")

func close():
	self.show()
	self.get_node('DoorCollisionShape').disabled = false

func door_pos_set(new_door_pos):
	self.rotation = new_door_pos.angle_to(Vector2(0, 1))
	self.position = new_door_pos*radius

func door_pos_get():
	return self.position/radius

func door_pos_rel_get():
	# Gets the door position relative to the Tile + global scene (horrible func name consider changing)
	return self.door_pos.rotated(self.Tile.global_rotation)

func facing(door):
	# If this door is directly facing another door (DISREGARDING DISTANCE) will return true, otherwise, false.
	return self.global_rotation == -door.global_rotation
