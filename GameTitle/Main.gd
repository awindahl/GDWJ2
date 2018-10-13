extends Node2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
var screensize
func _ready():
	screensize = get_viewport_rect().size
	self.position = screensize/2
	set_process_unhandled_input(true)

func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if !$pause.is_visible():
				$pause.show()
			else:
				$pause.hide()