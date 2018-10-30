extends Control

onready var gamedirector = get_node("/root/GameDirector")

var inventory = ["Lead Pipe","Dark dice","Cheese","Pack of Smokes","Holy Book","Bloody Note","Severed finger","Strange Book","Keys"] #add item from player

func _on_Panel_mouse_entered(nr):
	get_node("Container/item" + str(nr)).get_node("sprite2").show()
	$Label.text = inventory[nr] + "; " + GameDirector.dict[inventory[nr]]["desc"]

func _on_Panel_mouse_exited(nr):
	get_node("Container/item" + str(nr)).get_node("sprite2").hide()
	$Label.text = ""

func _add_item(itemName):
	get_node("Container/item" + str(itemName-1)).show()
