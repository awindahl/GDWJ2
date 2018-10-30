extends Node2D

onready var gamedirector = get_node("/root/GameDirector")

var pickup = preload("res://pickup.tscn")
var enemy = preload("res://enemy.tscn")

func _ready():
	GameDirector.i += 1
	print (get_parent().name)
	if get_parent().name == "EntrencehallBot" or get_parent().name == "EntrencehallMid" or get_parent().name == "EntrencehallTop" or get_parent().name == "Landing" or get_parent().name == "StairwayTile":
		queue_free()
	
	if get_parent().name == "ChapelTile" or get_parent().name == "ArtgalleryTile" or get_parent().name == "BallroomTile" or get_parent().name == "ClosetTile" or get_parent().name == "KitchenTile" or get_parent().name == "Laundromat" or get_parent().name == "RoundhallTile" or get_parent().name == "TreasuryTile" or get_parent().name == "WashroomTile" or get_parent().name == "WinecellarTile":
		var event = randi() % 6 + 1
		GameDirector.activate_event(event,0)

	var rand = randi() % 100 
	var item = randi() % 8 + 1
	var new_pickup = pickup.instance()

	var all_tiles_spawned
	
	if  GameDirector.i == GameDirector.tile_list.size() - 1 or  GameDirector.i > GameDirector.tile_list.size() - 1:
		all_tiles_spawned = true

	if all_tiles_spawned:
		item = 9
		new_pickup.itemNr = item
		add_child(new_pickup)
	elif !all_tiles_spawned:
			
		if rand < 70:
			if !get_parent().get_parent().get_parent().get_node("Player/CanvasLayer/hud").get_node("Control").get_node("Container/item" + str(item-1)).is_visible_in_tree():
				new_pickup.itemNr = item
				add_child(new_pickup)
			else:
				item = randi() % 8 + 1
				if !get_parent().get_parent().get_parent().get_node("Player/CanvasLayer/hud").get_node("Control").get_node("Container/item" + str(item-1)).is_visible_in_tree():
					new_pickup.itemNr = item
					add_child(new_pickup)


func spawn_enemy(type = ""):
	var new_enemy = enemy.instance()
	add_child(new_enemy)
