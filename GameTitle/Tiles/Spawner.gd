extends Node2D

var pickup = preload("res://pickup.tscn")
var enemy = preload("res://enemy.tscn")
var temp

func _ready():
	if get_parent().name == "ChapelTile" or get_parent().name == "ArtgalleryTile" or get_parent().name == "BallroomTile" or get_parent().name == "ClosetTile" or get_parent().name == "KitchenTile" or get_parent().name == "Laundromat" or get_parent().name == "RoundhallTile" or get_parent().name == "TreasuryTile" or get_parent().name == "WashroomTile" or get_parent().name == "WinecellarTile":
		var event = randi() % 6 + 1
		GameDirector.activate_event(event,0)
		
	# If last tile then spawn keys for sure. Else item spawn chance is 20%
	var all_tiles_spawned = GameDirector.tiles_placed.size() == GameDirector.tile_list.size()
	if all_tiles_spawned || randi() % 100 < 30:
		var item_to_spawn
		if all_tiles_spawned || GameDirector.items_spawned.size() == GameDirector.all_items.size() - 1:
			item_to_spawn = "Keys"
		elif GameDirector.items_spawned.size() < GameDirector.all_items.size() - 1:
			var items_left = GameDirector.get_items_left()
			if items_left.find("Keys"):
				items_left.remove(items_left.find("Keys"))
			item_to_spawn = items_left[randi() % items_left.size()]
			
			
		if item_to_spawn:
			GameDirector.items_spawned.append(item_to_spawn)
			var new_pickup = pickup.instance()
			new_pickup.itemNr = item_to_spawn
			add_child(new_pickup)