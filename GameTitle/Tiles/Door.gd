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
	self.position = new_door_pos*radius
	
func door_pos_get():
	return self.position/radius