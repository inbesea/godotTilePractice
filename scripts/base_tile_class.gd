extends Node2D

class_name Tile

# Keep track of neighbors
var north: Tile
var east: Tile
var south: Tile
var west: Tile
var area: Area2D
var new_position:Vector2
var held = false
var indicator
@onready var ship: TileMapLayer = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	area = $Area2D
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		update_tile_position_when_dragging()
		indicator.position = get_new_tile_position()
		

func update_tile_position_when_dragging():
	new_position = get_global_mouse_position()
	position = new_position

func _on_area_2d_input_event(viewport, event, shape_idx):
	#print(ship.get_cell_source_id(position))
	#print(position," Surrounding cells : ",ship.get_surrounding_cells(position))
	#print("Cell Data: ",ship.get_cell_tile_data(position))
	#print("Cell SourceID: ",ship.get_cell_source_id(position))
			
	if event.is_action_pressed("click"):
		held = true
		z_index = 5
		createIndicator()
		
	if event.is_action_released("click"):
		if(held == false):
			print("dropped dragged on a tile!")
		else:
			held = false
			z_index = 0
			set_this_to_indicator_position_and_remove_indicator()


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

func createIndicator():
		var indicator_scene = load("res://scenes/indicator_tile.tscn")
		indicator = indicator_scene.instantiate()
		indicator.z_index = 4
		get_node("StupidBufferNode").add_child(indicator)

func get_new_tile_position():
	var new_position : Vector2 = Vector2(200,200) # Dummy value

	# If we release on a tile we need to handle that

	var closest_tile:Vector2 = get_closest_tile_or_null().position

	var placement_vect = TileScript.get_vector_of_closest_side(closest_tile, get_global_mouse_position())

	#print("closest tile: (", (closest_tile.x - 32)/64, ",", (closest_tile.y - 32)/64 ,")")
	#print("placement_vect : ",snapped(placement_vect.x,64), ",", snapped(placement_vect.y,64))
	
	new_position.x = snapped(placement_vect.x, 64)
	new_position.y = snapped(placement_vect.y, 64)
	
	## Align to grid (BAD FIX)
	new_position.x -= 32
	new_position.y -= 32
	## The fix should probably align the grid so the positions are all correct. 
	
	return new_position



func get_closest_tile_or_null():
	var all_tiles:Array[Tile] = ship.get_tree().get_nodes_in_group("tiles") as Array[Tile]
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
