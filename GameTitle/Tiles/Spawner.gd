extends Node2D

var pickup = preload("res://pickup.tscn")
var enemy = preload("res://enemy.tscn")
var temp

func _ready():
	if get_parent().name == "ChapelTile" or get_parent().name == "ArtgalleryTile" or get_parent().name == "BallroomTile" or get_parent().name == "ClosetTile" or get_parent().name == "KitchenTile" or get_parent().name == "Laundromat" or get_parent().name == "RoundhallTile" or get_parent().name == "TreasuryTile" or get_parent().name == "WashroomTile" or get_parent().name == "WinecellarTile":
		var event = randi() % 6 + 1
		GameDirector.activate_event(event,0)
	
	var rand = randi() % 100
	if 1:
		var item = randi() % 8 + 1
		var new_pickup = pickup.instance()
		if !get_parent().get_parent().get_parent().get_node("Player/CanvasLayer/hud").get_node("Control").get_node("Container/item" + str(item-1)).is_visible_in_tree():
			
			if get_parent().get_parent().get_parent().get_node("Player/CanvasLayer/hud").get_node("Control").inventory.size() == 1:
				item = 9
		else:
			item = randi() % 8 + 1
			if !get_parent().get_parent().get_parent().get_node("Player/CanvasLayer/hud").get_node("Control").get_node("Container/item" + str(item-1)).is_visible_in_tree():
				new_pickup.itemNr = item
				add_child(new_pickup)

func spawn_enemy(type = ""):
	var new_enemy = enemy.instance()
	add_child(new_enemy)