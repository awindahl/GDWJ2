extends Node
var mute1 = preload("res://Asset Lib/Art/mute_btn_inactive.png")
var mute2 = preload("res://Asset Lib/Art/mute_btn_active.png")

var muted = false
var playing = true
var position
var swapping = true

func _ready():
	OS.center_window()
	OS.set_window_title("Ekin's and Alexander's tilehouse")
	$AnimationPlayer.play("fadeInSplash1", -1)
	
	$Control/VolumeSlider.value = GameDirector.volume
	$Control/AudioStreamPlayer2D.volume_db = GameDirector.volume-25
	playing = GameDirector.playing
	if playing:
		$Control/music_sprite.set_texture(mute2)
	else:
		$Control/music_sprite.set_texture(mute1)
		$Control/AudioStreamPlayer2D.stop()


	set_process(true)
	
func _process(delta):
	if swapping:
		if $AnimationPlayer.get_current_animation() == "fadeInSplash1":
			if Input.is_action_pressed("ui_splash_skip") and swapping:
				swapping = false
				$AnimationPlayer.stop(false)
				splash1()
				$timer.start()
	
		elif $AnimationPlayer.get_current_animation() == "fadeInSplash2":
			if Input.is_action_pressed("ui_splash_skip") and swapping:
				$AnimationPlayer.stop(false)
				splash2()
				hide_square()
	else:
		if $timer.time_left < 1 :
			swapping = true

func _on_quit_btn_down():
	get_tree().quit()

func _on_play_btn_down():
	transition.fade_to("res://Main.tscn")

func _on_fullscreen_pressed():
	OS.set_window_resizable(true)
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)
	OS.set_window_resizable(false)

func _on_music_btn_pressed():
	if playing:
		playing = !playing
		$Control/music_sprite.set_texture(mute1)
		$Control/AudioStreamPlayer2D.stop()
	else:
		playing = !playing
		$Control/music_sprite.set_texture(mute2)
		$Control/AudioStreamPlayer2D.volume_db = $Control/VolumeSlider.value-25
		$Control/AudioStreamPlayer2D.play(0)
	GameDirector.playing = playing

func _on_VolumeSlider_value_changed(value):
	if playing:
		if value < 1:
			position = $Control/AudioStreamPlayer2D.get_playback_position()
			$Control/AudioStreamPlayer2D.stop()
			muted = !muted
		else:
			if muted:
				muted = !muted
				$Control/AudioStreamPlayer2D.play(position)
			$Control/AudioStreamPlayer2D.volume_db = $Control/VolumeSlider.value-25
	GameDirector.volume = $Control/VolumeSlider.value

func _on_AudioStreamPlayer2D_finished():
	$Control/AudioStreamPlayer2D.play(0)

func splash1():
	$splash1.hide()
	$AnimationPlayer.play("fadeInSplash2", -1)

func splash2():
	$splash2.hide()

func hide_square():
	$black_square.hide()