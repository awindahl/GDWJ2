extends Node2D

var upper_landing
var BaseTile = load("res://Tiles/BaseTile.tscn")

func add_tile(tile):
	tile.add_to_group('tiles')
	self.add_child(tile)

func remove_tile(tile):
	tile.remove_from_group('tiles')
	self.remove_child(tile)

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	upper_landing = BaseTile.instance()
	self.add_tile(upper_landing)
	# Put tile in right place before adding child
	
	


#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
