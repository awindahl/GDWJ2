extends Node2D

var screensize
var playing = true

func _ready():
	playing = GameDirector.playing
	$Player/CanvasLayer/pause/HSlider.value = GameDirector.volume
	$background_music.volume_db = GameDirector.volume-25
	if playing:
		$background_music.play(0)

	$Player/CanvasLayer/hud/objective.text = GameDirector.currentObjective
	
	screensize = get_viewport_rect().size
	self.position = screensize/2
	set_process_unhandled_input(true)

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