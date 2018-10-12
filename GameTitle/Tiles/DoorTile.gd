extends Node2D

export(bool) var doorLeft
export(bool) var doorRight
export(bool) var doorUp
export(bool) var doorDown

func _process(delta):
	if doorLeft == true:
		$"Door Left".show()
	if doorLeft == false:
		$"Door Left".hide()
		
	if doorRight == true:
		$"Door Right".show()
	if doorRight == false:
		$"Door Right".hide()
		
	if doorUp == true:
		$"Door Up".show()
	if doorUp == false:
		$"Door Up".hide()
	
	if doorDown == true:
		$"Door Down".show()
	if doorDown == false:
		$"Door Down".hide()