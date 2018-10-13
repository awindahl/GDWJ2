extends CanvasLayer

var path = ""
var time = 1.0

func _ready():
	$AnimationPlayer.play("fadeOut", -1, time)

func fade_to(scn_path, scn_time = 1.0):
	for i in get_tree().get_root().get_children():
		if i.get_name() != "transition":
			print(i.get_name())
			i.get_tree().set_pause(true)
			break

	self.path = scn_path # store the scene path
	self.time = scn_time
	$AnimationPlayer.play("fadeIn", -1, time) # play the transition animation

func change_scene():
	if path != "":
		get_tree().change_scene(path)
		for i in get_tree().get_root().get_children():
			if i.get_name() != "transition":
				print(i.get_name())
				i.get_tree().set_pause(false)
				break

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "fadeIn":
		change_scene()
		$AnimationPlayer.play("fadeOut", -1, time)
#It appears as function tracks on animationplayer doesnt work atm, split up the transition into two instead.