extends Node2D

const TYPE = "DOOR"

var door_pos setget door_pos_set, door_pos_get
var door_pos_rel setget , door_pos_rel_get
var next_tile_pos setget , next_tile_pos_get
var radius = 208
var is_open = false

var Tile	# Shouldn't rely on having Tile and Grid too much otherwise could be problems in the future (2-way comms)
var Grid

func _ready():
	self.Tile = self.get_parent()
	self.Grid = self.Tile.get_parent()

func open():
	if !self.is_open:
		self.disable()
		self.is_open = true
		$hitbox.queue_free() # This deletes the hitbox so beware future self

func close():
	if self.is_open:
		self.show()
		self.is_open = false
		
func enable():
	self.show()
	$DoorCollisionShape.disabled = false

func disable():
	self.hide()
	$DoorCollisionShape.disabled = true

func door_pos_set(new_door_pos):
	self.rotation = new_door_pos.angle_to(Vector2(0, 1))
	self.position = (new_door_pos*radius).round()

func door_pos_get():
	return (self.position/radius).round()

func door_pos_rel_get():
	# Gets the door position relative to the Tile + global scene (horrible func name consider changing)
	return (self.door_pos.rotated(self.Tile.global_rotation)).round()

func points_to(tile):
	# This function returns true if this door points towards an adjacent tile.
	return tile.tile_pos == self.next_tile_pos
	
func next_tile_pos_get():
	# This function returns the expected coordinates of the tile which this door is pointing to
	return self.Tile.tile_pos + self.door_pos_rel
