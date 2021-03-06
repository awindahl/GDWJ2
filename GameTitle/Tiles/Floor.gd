extends Node2D
var spawned_tiles

onready var gamedirector = get_node("/root/GameDirector")

var tiles

func _init():
	self.tiles = []

func _ready():
	self.spawned_tiles = []
	for child in self.get_children():
		if child.get("TYPE") == "TILE":
			self.tiles.append(child)
		#	self._on_tile_constructed(child) # Need this here because _ready() happens after tiles are constructed
		
func add_tile(tile):
	self.add_child(tile)
	self.register_tile(tile)

func register_tile(tile):
	tile.connect("moved", self, "_on_Tile_moved")
	if tile.TYPE == "TILE":
		GameDirector.tiles_placed.append(tile)
		self.tiles.append(tile)

func remove_tile(tile):
	self.tiles.remove(tiles.find(tile))
	self.remove_child(tile)
	
func find_tile(pos):
	for tile in self.tiles:
		if tile.tile_pos == pos:
			return tile
	return null

func get_adjacent_tiles(tile):
	var adjacent_tiles = []
	for tile_pos in tile.adjacent_tile_positions:
		var other_tile = find_tile(tile_pos)
		if other_tile:
			adjacent_tiles.append(other_tile)
	return adjacent_tiles

# Signal callbacks
func _on_Tile_moved(tile):
	# If a tile is moved then find all adjacent Tiles and open doors if they are connected. Else, close them.
	for door in tile.doors:
		var adjacent_tile = self.find_tile(door.next_tile_pos)
		if adjacent_tile:
			var opposite_door = adjacent_tile.find_door(door.opposite_door_pos_rel)
			if opposite_door:
				if opposite_door.is_wall && !door.is_wall:
					door.board()
				elif !opposite_door.is_wall && door.is_wall:
					opposite_door.board()
				else:
					door.open()
					opposite_door.open()
			else:
				door.close()
		else:
			door.close()
	
func _on_Player_requesting_door_to_open(door):
	var the_floor = door.get_parent().get_parent()	# Terrible hack but we'll live with it
	if self != the_floor:
		return
		
	if self.find_tile(door.next_tile_pos):
		print("Can't add a room here - already a room next door!")
		return

	if !door.is_visible_in_tree():
		print("Shhh I'm a door but I don't really exist! Can't open me ;)")
		return
	var tile_list = GameDirector.get_tiles_left(self.name)
	var last_tile = false
	match tile_list.size():
		1:
			last_tile = true
		0:
			print("No more tiles left for this floor!")
			return
	
	var new_tile = tile_list[randi() %  tile_list.size()]
	self.add_tile(new_tile)
	
	if last_tile:
		for tile in self.tiles:
			for door in tile.doors:
				if !door.is_open:
					door.board()
	new_tile.tile_pos = door.next_tile_pos	# Delet dis
	
	# Algorithm for choosing rotation here
	# Ensure three rules are satisfied:
	# 1) Door being opened is connected
	# 2) Number of total connections is maximised
	# 3) When there's a tie, randomise the solutions
	# new_tile.global_rotation = door.door_pos_rel.angle() + Vector2(0, 1).angle()	# Not certain about this but hey-ho
	var possible_rotations = []
	
	# Simulate doors
	for i in range(4):
		var opposite_door = new_tile.find_door(door.opposite_door_pos_rel)
		if !opposite_door.is_wall:
			possible_rotations.append([new_tile.global_rotation, self.connected_doors(new_tile).size()])
		# That's Numberwang! Rotate the board!
		new_tile.rotate_clockwise()
	
	# Find max connection number of these entries
	var max_connections = 0
	for possible_rotation in possible_rotations:
		max_connections = max(max_connections, possible_rotation[1])
	
	var good_rotations = []
	for possible_rotation in possible_rotations:
		if max_connections == possible_rotation[1]:
			good_rotations.append(possible_rotation[0])
			
	# Choose a random selection from the good_rotations
	new_tile.global_rotation = good_rotations[randi() %  good_rotations.size()]
	self.spawned_tiles.append(new_tile)
	self._on_Tile_moved(new_tile)	# Do this manually for the time being
	
func connected_doors(tile):
	# This function returns all of the doors which are adjacent to a tile. "Connected" in this sense means if the door is not a wall instead
	var connected_doors = []
	for door in tile.doors:
		var other_tile = self.find_tile(door.next_tile_pos)
		if other_tile:
			for other_door in other_tile.doors:
				if other_door.is_visible_in_tree() && door.is_visible_in_tree() && other_door.opposite_to_door(door):
					connected_doors.append(door)
	return connected_doors
