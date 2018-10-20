extends Node

func _ready():
	if get_parent().name == "ChapelTile" or get_parent().name == "ArtgalleryTile" or get_parent().name == "BallroomTile" or get_parent().name == "ClosetTile" or get_parent().name == "KitchenTile" or get_parent().name == "Laundromat" or get_parent().name == "RoundhallTile" or get_parent().name == "TreasuryTile" or get_parent().name == "WashroomTile" or get_parent().name == "WinecellarTile":
		var event = randi() % 6 + 1
		GameDirector.activate_event(event,0)