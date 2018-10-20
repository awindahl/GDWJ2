extends Node2D

var pickup = preload("res://pickup.tscn")

func _ready():
	if get_parent().name == "ChapelTile" or get_parent().name == "ArtgalleryTile" or get_parent().name == "BallroomTile" or get_parent().name == "ClosetTile" or get_parent().name == "KitchenTile" or get_parent().name == "Laundromat" or get_parent().name == "RoundhallTile" or get_parent().name == "TreasuryTile" or get_parent().name == "WashroomTile" or get_parent().name == "WinecellarTile":
		var event = randi() % 6 + 1
		GameDirector.activate_event(event,0)
	
	var rand = randi() % 100
	
	var arr = get_parent().get_parent().get_parent().get_node("Player/CanvasLayer/hud").get_node("Control").temp
	
	if 1:
		var item = randi() % 8 + 1
		var new_pickup = pickup.instance()
	
		for i in arr:
			if !item == i:
				arr.append(item)
				new_pickup.itemNr = item
				add_child(new_pickup)
				print(arr)
			else:
				pass
