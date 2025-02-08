extends TileMapLayer

const Tile := preload("res://scenes/base_tile_class.tscn")
#const Tile = preload("res://scenes/base_tile_class.tscn")
#include("res://scenes/base_tile_class.tscn")
#preload("res://scenes/base_tile_class.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		
		var global_pos = get_global_mouse_position()
		var pos = global_pos
		pos.x = snapped( (pos.x - 32),64 ) / 64
		pos.y = snapped( (pos.y - 32),64 ) / 64
		
		print("neighbors to ", pos , " : " , get_surrounding_cells(pos))
		
		var tile:Tile = get_tile(global_pos)
		if(tile != null):
			print(tile.position)

func get_all_tiles() -> Array[Node]:
	var all_tiles:= get_tree().get_nodes_in_group("tiles")
	
	for obj in all_tiles:
		print("is ", obj, " type tile ", obj.get_class() == "Tile")
		print(obj.get_class())
		
	return all_tiles

func get_tile_from_indices(posIndex : Vector2i) -> Tile:
	var all_tiles = get_tree().get_nodes_in_group("tiles")
	var returnTile:Tile = null
	for tile in all_tiles:
		tile is Tile
		if tile.index == posIndex:
			if returnTile != null:
				print("Issue with overlapping indices encountered for index :", tile.index)
			else: 
				returnTile = tile
			
		#print("Index: ",tile.index)
		
	if returnTile == null:
		return null
	return returnTile

## Pass in world co-ords and they will be translated to index values
func get_tile(pos:Vector2i) -> Tile:
	var all_tiles = get_tree().get_nodes_in_group("tiles")
	var returnTile:Tile = null
	var posIndex = TileScript.get_tile_index(pos)
	for tile in all_tiles:
		tile is Tile
		if tile.index == posIndex:
			if returnTile != null:
				print("Issue with overlapping indices encountered for index :", tile.index)
			else: 
				returnTile = tile
			
		#print("Index: ",tile.index)
		
	if returnTile == null:
		return null
	return returnTile

func get_closest_internal_vacancy(pos : Vector2) -> Vector2:
	var return_vector : Vector2 = Vector2(200,200)
	var all_tiles = get_tree().get_nodes_in_group("tiles")
	var closest_edge : Tile
	
	for tiles in all_tiles:
		if (all_tiles.size() == 0):
			return pos # Return starting value if there are no tiles lol
		for tile in all_tiles:
			if !tile.isEdge: 
				continue # Remove non-edgers from consideration
			if closest_edge == null: # Fill in the closest edge
				if tile.isEdge : closest_edge = tile # iiiif the tile is edge
				else : continue # if not then skip
			var distance_to_this_tile = pos.distance_squared_to(tile.global_position)
			var distance_to_closest_tile = pos.distance_squared_to(closest_edge.global_position)
			if (distance_to_this_tile < distance_to_closest_tile):
				closest_edge = tile
				return_vector = closest_edge.position
	
	if !closest_edge.isEdge : 
		print("WTF why are you not edge")
	var side_candidates = get_empty_diagonals(closest_edge)
	side_candidates.append_array(closest_edge.get_empty_side_vectors())
	
	return_vector = TileScript.get_closest_vect(side_candidates, pos)
	
	return return_vector

func get_empty_diagonals(closest_edge_tile:Tile) -> Array[Vector2]:
	var results : Array[Vector2]
	var downRight = Vector2(closest_edge_tile.position.x + 64,closest_edge_tile.position.y + 64)
	var downLeft = Vector2(closest_edge_tile.position.x - 64,closest_edge_tile.position.y + 64)
	var upRight = Vector2(closest_edge_tile.position.x + 64,closest_edge_tile.position.y - 64)
	var upLeft = Vector2(closest_edge_tile.position.x - 64,closest_edge_tile.position.y - 64)

# If a tile is not there it is valid for placement
	if get_tile(downRight) == null:
		results.append(downRight)
	if get_tile(downLeft) == null :
		results.append(downLeft)
	if get_tile(upLeft) == null :
		results.append(upLeft)
	if get_tile(upRight) == null :
		results.append(upRight)
	return results

func get_closest_tile_or_null():
	var all_tiles = get_tree().get_nodes_in_group("tiles")
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
