extends Node2D

signal door_opened(door)
var door_pos setget door_pos_set, door_pos_get

var radius = 208

func _ready():
	var Grid = get_node("/root/Main/Grid")
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
	
func is_connected(other_door):
	var this_tile = self.get_parent()
	var other_tile = other_door.get_parent()
	if this_tile.adjacent_to(other_door):
		#TODO
		pass
	else:
		return false
	