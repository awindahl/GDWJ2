extends Node2D

var screensize
var playing = true

func _ready():
	GameDirector.connect("change_objective", self, "_update_objective")
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