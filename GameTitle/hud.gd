extends Control

func _ready():
	GameDirector.connect("hud_update", self, "_hud_update")
	$sanity/nr.text = str(GameDirector.sanity)
	$strength/nr.text = str(GameDirector.strength)

func _hud_update():
	$sanity/nr.text = str(GameDirector.sanity)
	$strength/nr.text = str(GameDirector.strength)
