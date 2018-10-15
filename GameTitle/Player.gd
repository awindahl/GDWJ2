extends KinematicBody2D
signal player_requesting_door_to_open
var SPEED = 100

func _process(delta):
	
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var movedir = Vector2(0,0)
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	var body = self.move_and_slide(movedir*SPEED)
	
	var mousePos = $Camera2D.get_global_mouse_position()
	$AnimatedSprite.rotate($AnimatedSprite.get_angle_to(mousePos)+deg2rad(90))
	
	if movedir != Vector2(0,0):
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	
	for area in $hitbox.get_overlapping_areas():
		var overlap = area.get_parent()
	
		if overlap.get("TYPE") == "DOOR":
			if Input.is_action_just_released("ui_accept"):
				emit_signal("player_requesting_door_to_open", overlap)
