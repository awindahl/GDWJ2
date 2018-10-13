extends Node

var fullscreen = false
var muted = false
var playing = true
var position

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	OS.center_window()
	OS.set_window_title("Not haunted house on the hill")
	$Control/VolumeSlider.value = 25
	$Control/AudioStreamPlayer2D.volume_db = 0


func _on_quit_btn_down():
	get_tree().quit()


func _on_play_btn_down():
	get_tree().change_scene("res://Main.tscn")


func _on_fullscreen_btn_pressed():
	if fullscreen:
		fullscreen = !fullscreen
		OS.window_fullscreen = false
	else:
		fullscreen = !fullscreen
		OS.window_fullscreen = true

func _on_music_btn_pressed():
	if playing:
		playing = !playing
		$Control/AudioStreamPlayer2D.stop()
	else:
		playing = !playing
		$Control/AudioStreamPlayer2D.volume_db = $Control/VolumeSlider.value-25
		$Control/AudioStreamPlayer2D.play(0)

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
