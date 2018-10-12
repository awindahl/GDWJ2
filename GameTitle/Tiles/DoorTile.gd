extends Node2D

#in editor, set door to true to have a door, else it will be a wall
#TODO make doors objects that move when interacted with?
export(bool) var doorLeft
export(bool) var doorRight
export(bool) var doorUp
export(bool) var doorDown

func _process(delta):
	if doorLeft == true:
		$"Door Left".show()
	if doorLeft == false:
		$"Door Left".hide()
		$"Wall Left".show()
		
	if doorRight == true:
		$"Door Right".show()
	if doorRight == false:
		$"Door Right".hide()
		$"Wall Right".show()
		
	if doorUp == true:
		$"Door Up".show()
	if doorUp == false:
		$"Door Up".hide()
		$"Wall Up".show()
	
	if doorDown == true:
		$"Door Down".show()
	if doorDown == false:
		$"Door Down".hide()
		$"Wall Down".show()