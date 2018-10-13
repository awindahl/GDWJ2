extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screensize
func _ready():
	screensize = get_viewport_rect().size
	self.position = screensize/2
