extends KinematicBody2D
signal player_requesting_door_to_open
signal changing_floors
var SPEED = 150

func _process(delta):
	
	var LEFT = Input.is_action_pressed("ui_left")
	var RIGHT = Input.is_action_pressed("ui_right")
	var UP = Input.is_action_pressed("ui_up")
	var DOWN = Input.is_action_pressed("ui_down")
	var movedir = Vector2(0,0)
	
	movedir.x = -int(LEFT) + int(RIGHT)
	movedir.y = -int(UP) + int(DOWN)
	
	if (Input.is_action_just_pressed("ui_left") or Input.is_action_just_pressed("ui_right") or Input.is_action_just_pressed("ui_up") or Input.is_action_just_pressed("ui_down")) and $Walking.playing == false:
		$Walking.play()
	elif movedir == Vector2(0,0):
		 $Walking.stop()
	
	var body = self.move_and_slide(movedir*SPEED)
	
	var mousePos = $Camera2D.get_global_mouse_position()
	$AnimatedSprite.rotate($AnimatedSprite.get_angle_to(mousePos)+deg2rad(90))
	
	if movedir != Vector2(0,0):
		$AnimatedSprite.playing = true
	else:
		$AnimatedSprite.playing = false
		$AnimatedSprite.frame = 0
	
	for area in $hitbox.get_overlapping_areas():
		match area.name:
			"DoorHitbox":
				var door = area.get_parent()
				if door.can_open() && Input.is_action_just_released("ui_accept"):
					emit_signal("player_requesting_door_to_open", door)
			"GroundFloorStairs":
				var tile = area.get_parent()
				if Input.is_action_just_released("ui_accept"):
					emit_signal("changing_floors", tile, area.name)
			"FirstFloorStairs":
				var tile = area.get_parent()
				if Input.is_action_just_released("ui_accept"):
					emit_signal("changing_floors", tile, area.name)
			"GroundFloorHatchDown":
				var tile = area.get_parent()
				if Input.is_action_just_released("ui_accept"):
					emit_signal("changing_floors", tile, area.name)
			"BasementStairs":
				var tile = area.get_parent()
				if Input.is_action_just_released("ui_accept"):
					emit_signal("changing_floors", tile, area.name)
			"FrontDoor":
				if Input.is_action_just_released("ui_accept"):
					if $CanvasLayer/hud/Control/Container/item8.is_visible_in_tree():
						transition.fade_to("res://win.tscn")
					else:
						print("door stuck")
			"enemy":
				GameDirector.fight(area.get_parent())

		var overlap = area.get_parent()
		if overlap.get("TYPE") == "ITEM":
			if Input.is_action_just_released("ui_accept"):
				GameDirector.activate_rule(overlap.itemNr)
				get_node("CanvasLayer/hud/Control")._add_item(overlap.itemNr)
				overlap.queue_free()
				$PickingUpItem.play()