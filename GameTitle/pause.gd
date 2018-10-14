extends Control

var position
var muted = false
func _ready():
	pass

func _on_quit_pressed():
	transition.fade_to("res://menu.tscn", 1)

func _on_resume_pressed():
	self.hide()

func _on_fullscreen_pressed():
	OS.set_window_resizable(true)
	if OS.is_window_fullscreen():
		OS.set_window_fullscreen(false)
	else:
		OS.set_window_fullscreen(true)
	OS.set_window_resizable(false)


func _on_HSlider_value_changed(value):
	if get_parent().get_parent().get_parent().playing:
		if value < 1:
			position = get_parent().get_parent().get_parent().get_node("background_music").get_playback_position()
			get_parent().get_parent().get_parent().get_node("background_music").stop()
			muted = !muted
		else:
			if muted:
				muted = !muted
				get_parent().get_parent().get_parent().get_node("background_music").play(position)
			get_parent().get_parent().get_parent().get_node("background_music").volume_db = $HSlider.value-25
	GameDirector.volume = $HSlider.value


func _on_music_pressed():
	if get_parent().get_parent().get_parent().playing:
		get_parent().get_parent().get_parent().playing = !get_parent().get_parent().get_parent().playing
		get_parent().get_parent().get_parent().get_node("background_music").stop()
	else:
		get_parent().get_parent().get_parent().playing = !get_parent().get_parent().get_parent().playing
		get_parent().get_parent().get_parent().get_node("background_music").volume_db = $HSlider.value-25
		get_parent().get_parent().get_parent().get_node("background_music").play(0)
	GameDirector.playing = get_parent().get_parent().get_parent().playing
