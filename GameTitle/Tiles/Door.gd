extends Node2D

signal door_opened(door)

var BaseTile = preload("res://Tiles/Tile.tscn")

export(int) var pos

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