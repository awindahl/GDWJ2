extends Node2D

#in editor, set door to true to have a door, else it will be a wall
#TODO make doors objects that move when interacted with?
export(bool) var doorLeft
export(bool) var doorRight
export(bool) var doorUp
export(bool) var doorDown
		
func open():
	self.hide()
	self.get_node('DoorCollisionShape').disabled = true
	
func close():
	self.show()
	self.get_node('DoorCollisionShape').disabled = false
	