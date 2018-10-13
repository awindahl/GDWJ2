extends KinematicBody2D

var SPEED = 2

func _process(delta):
	
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var movedir = Vector2(0,0)
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	var body = self.move_and_collide(movedir*SPEED)
	
	var mousePos = $Camera2D.get_global_mouse_position()
	self.rotate(self.get_angle_to(mousePos)+deg2rad(90))
	
	if movedir != Vector2(0,0):
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	
	# Check for collisions
	if body:
		var cs = body.collider_shape
		# If collision is with a door
		if cs.name == "DoorCollisionShape":
			var door = cs.owner
			door.open()
	else:
		pass
