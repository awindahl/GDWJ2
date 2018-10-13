extends KinematicBody2D

var speed = 300

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _process(delta):
	var velocity = Vector2() # The player's movement vector.
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
	var body = self.move_and_collide(velocity * delta)
	
	# Check for collisions
	if body:
		var cs = body.collider_shape
		# If collision is with a door
		if cs.name == "DoorCollisionShape":
			var door = cs.owner
			door.open()
