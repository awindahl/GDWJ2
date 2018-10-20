extends Node2D

export(bool) var wall setget wall_set, wall_get
var door_pos_rel setget , door_pos_rel_get
var door_pos setget door_pos_set, door_pos_get
var opposite_door_pos_rel setget , opposite_door_pos_rel_get
var next_tile_pos setget , next_tile_pos_get
var radius = 208
var is_open
var is_wall

var Tile	# Shouldn't rely on having Tile and Floor too much otherwise could be problems in the future (2-way comms)

func _ready():
	self.Tile = self.get_parent()
	self.is_open = false
	self.wall = self.wall

func open():
	if self.can_open():
		self.disable()
		self.is_open = true

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

func opposite_door_pos_rel_get():
	return -self.door_pos_rel

func wall_set(new_bool):
	if self.has_node("BlockerCollisionShape") && self.has_node("BlockerLightOccluder"):
		$BlockerCollisionShape.disabled = !new_bool
		if new_bool:
			$BlockerLightOccluder.show()
		else:
			$BlockerLightOccluder.hide()
			
	if new_bool == null:
		self.is_wall = false
	else:
		self.is_wall = new_bool

func wall_get():
	return self.is_wall

func can_open():
	return !self.is_open && !self.is_wall

func points_to_tile(tile):
	# This function returns true if this door points towards an adjacent tile.
	return tile.tile_pos == self.next_tile_pos

func opposite_to_door(door):
	# This function returns true if two doors are pointing in opposite directions
	return door.door_pos == -self.door_pos

func next_tile_pos_get():
	# This function returns the expected coordinates of the tile which this door is pointing to
	return self.Tile.tile_pos + self.door_pos_rel
