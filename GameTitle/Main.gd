extends Node2D

var screensize
var playing = true

func _ready():
	GameDirector.connect("change_objective", self, "_update_objective")
	GameDirector.connect("spawn", self, "spawn_on_random_tiles")
	playing = GameDirector.playing
	$Player/CanvasLayer/pause/HSlider.value = GameDirector.volume
	$background_music.volume_db = GameDirector.volume-25
	if playing:
		$background_music.play(0)
	
	screensize = get_viewport_rect().size
	self.position = screensize/2
	set_process_unhandled_input(true)
	
	$Player/CanvasLayer/popover.display("Just need to use the phone. \n\n Your car broke down just outside this old house. After knocking on the door you try entering. The door slams behind you, locking itself. You have to find the keys to the house to get out! \n\n Find the house keys and make it back out.", "res://Asset Lib/Art/mute_btn_active.png", "res://Asset Lib/Art/popoverbg.png")
	GameDirector.currentObjective = "Find the house keys"
	_update_objective()
	
func _unhandled_input(event):
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_ESCAPE:
			if !$Player/CanvasLayer/pause.is_visible():
				$Player/CanvasLayer/pause.show()
				get_tree().paused = true
			else:
				$Player/CanvasLayer/pause.hide()
	
	if event is InputEventKey:
		if event.pressed and event.scancode == KEY_Z:
			$Player/CanvasLayer/popover.display("Hello, this is the test popover", "res://Asset Lib/Art/mute_btn_active.png", "res://Asset Lib/Art/popoverbg.png")
			

func _update_objective():
	$Player/CanvasLayer/hud/objective.text = GameDirector.currentObjective

func _on_Player_changing_floors(tile, stairs):
	# Just hardcode the locations for now...
	var vector
	var stairs_name
	var floor_name
	match stairs:
		"GroundFloorStairs":
			vector = Vector2(0, 0)
			floor_name = "FirstFloor"
			stairs_name = "FirstFloorStairs"
		"FirstFloorStairs":
			vector = Vector2(0, -2)
			floor_name = "GroundFloor"
			stairs_name = "GroundFloorStairs"
		"GroundFloorHatchDown":
			vector = Vector2(0, 0)
			floor_name = "Basement"
			stairs_name = "BasementStairs"
		"BasementStairs":
			vector = Vector2(0, -1)
			floor_name = "GroundFloor"
			stairs_name = "GroundFloorHatchDown"
	transition.fade_in()
	var t = Timer.new() 		# Create a new Timer node
	t.set_wait_time(1.0) 		# Set the wait time
	add_child(t)			# Add it to the node tree as the direct child
	t.start()			# Start it
	$WalkingOnStairs.play()
	yield(t, "timeout")		# Finally, make the script stop with the yield
	$Player.global_position = self.find_node(floor_name).find_tile(vector).get_node(stairs_name).get_node("CollisionShape2D").global_position
	transition.fade_out()

func spawn_on_random_tiles():
	if GameDirector.spawnNr+3 < GameDirector.tiles_placed.size():
		var number
		var prevnr = -1
		for i in GameDirector.spawnNr:
			number = randi() % (GameDirector.tiles_placed.size()-1)
			if number == prevnr:
				GameDirector.tiles_placed[number].get_node("Spawner").spawn_enemy()
				prevnr = number
				i = i - 1
	
	
	
	