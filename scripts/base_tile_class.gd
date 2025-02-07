extends Node2D

class_name Tile

# Keep track of neighbors
var north: Tile
var east: Tile
var south: Tile
var west: Tile
var index: Vector2i
var isEdge : bool

var area: Area2D
var label : Label
var new_position:Vector2
var held = false
var indicator
@onready var ship: TileMapLayer = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	area = $Area2D
	label = $Label
	update_index()
	update_neighbors()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		update_tile_position_when_dragging()
		indicator.position = get_new_tile_position()

func update_index():
	index = TileScript.get_tile_index(position)

func update_tile_position_when_dragging():
	new_position = get_global_mouse_position()
	position = new_position

func _on_area_2d_input_event(viewport, event, shape_idx):
			
	if event.is_action_pressed("click"): # Pickup
		held = true
		z_index = 5
		createIndicator()
		self_pickup()
		print(ship.get_tile(get_global_mouse_position()))
		
	if event.is_action_released("click"): # Released
		if(held == false):
			print("dropped dragged on a tile!")
		else:
			held = false
			z_index = 0
			set_this_to_indicator_position_and_remove_indicator()
			self.add_to_group("tiles")
			print("Position: ", position, " index: ", index)


#func get_clicked_tile_power():
	#var clicked_cell = ship.local_to_map(ship.get_local_mouse_position())
	#var data = ship.get_cell_tile_data(clicked_cell)
	#if data:
		#return data.get_custom_data("power")
	#else:
		#return 0

func set_this_to_indicator_position_and_remove_indicator():
	if indicator != null:
		position = indicator.position # Set to the indicator
		indicator.queue_free()
		update_index()
		update_neighbors()

func self_pickup():
	var side_inices:Array[Vector2i] = ship.get_surrounding_cells(index)
	if east != null : 
		east.west = null # Remove ourselves from old
		east.update_isEdge() # Update old tile's edge status
		
	if south != null : 
		south.north = null
		south.update_isEdge()
	
	if west != null : 
		west.east = null
		west.update_isEdge()
	
	if north != null : 
		north.south = null
		north.update_isEdge()
	
	self.remove_from_group("tiles")

## Creates references to the neighbors. 
func update_neighbors():
	# Get indices around self and set each side to the tile there, nulling out self from the previous
	# tile neighbors. 
	var side_inices:Array[Vector2i] = ship.get_surrounding_cells(index)
	east = ship.get_tile_from_indices(side_inices[0]) # try to get new tile
	if east != null : # Update new tile with neighbor info. 
		east.west = self
		east.update_isEdge()
		
	south = ship.get_tile_from_indices(side_inices[1])
	if south != null : 
		south.north = self
		south.update_isEdge()
	
	west = ship.get_tile_from_indices(side_inices[2])
	if west != null : 
		west.east = self
		west.update_isEdge()
	
	north = ship.get_tile_from_indices(side_inices[3])
	if north != null : 
		north.south = self
		north.update_isEdge()
	
	# Set isEdge based on the number of neighbors
	update_isEdge()

func count_neighbors() -> int:
	var count : int = 0
	if east != null : count += 1
	if south != null : count += 1
	if west != null : count += 1
	if north != null : count += 1
	print("neighbor count is : ",count)
	return count

func update_isEdge():
	if count_neighbors() < 4 :
		isEdge = true
		print("setting to true!")
	else:
		isEdge = false
		print("setting to false!")
	
	var str = "Is Edge:\n {0}"
	label.set_text(str.format([isEdge]))
	print("isEdge:",isEdge)

func createIndicator():
		var indicator_scene = load("res://scenes/indicator_tile.tscn")
		indicator = indicator_scene.instantiate()
		indicator.z_index = 4
		get_node("StupidBufferNode").add_child(indicator)

func get_new_tile_position():
	var global_mouse_pos = get_global_mouse_position()
	var new_position : Vector2 = Vector2(200,200) # Dummy value

	# If we release on a tile we need to handle that
	var tile_under_current_position = ship.get_tile(global_mouse_pos)
	
	if tile_under_current_position == null : 
		var closest_tile:Vector2 = get_closest_tile_or_null().position
		var placement_vect = TileScript.get_vector_of_closest_side(closest_tile, get_global_mouse_position())	
		new_position.x = snapped(placement_vect.x, 64)
		new_position.y = snapped(placement_vect.y, 64)
	else : # Dropped on a tile
		var closest_internal_vacancy : Vector2 = ship.get_closest_internal_vacancy(global_mouse_pos)
	
	## Align to grid (BAD FIX)
	new_position.x -= 32
	new_position.y -= 32
	## The fix should probably align the grid so the positions are all correct. 
	
	return new_position

func get_closest_tile_or_null():
	var all_tiles = ship.get_tree().get_nodes_in_group("tiles")
	var closest_tile = null
		
	if (all_tiles.size() > 0):
		if all_tiles[0] == self:
			closest_tile = all_tiles[1]
		else:
			closest_tile = all_tiles[0]
			
		for tile in all_tiles:
			if tile == self:
				continue
			var distance_to_this_tile = global_position.distance_squared_to(tile.global_position)
			var distance_to_closest_tile = global_position.distance_squared_to(closest_tile.global_position)
			if (distance_to_this_tile < distance_to_closest_tile):
				closest_tile = tile

	#print(closest_tile.position)
	return closest_tile

func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	pass # Replace with function body.
