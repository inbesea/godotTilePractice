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
		#set_cell(pos, 1, Vector2(0,0), 0 )
		#set_cell()
		
		#print(pos)
		#print("tile cell atlas id : ", get_cell_atlas_coords(pos))
		#print("cell source id :", get_cell_source_id(pos))
		#print("cell tile data :", get_cell_tile_data(pos))
		print("neighbors to ", pos , " : " , get_surrounding_cells(pos))
		#get_tile(pos)
		#print("All tiles:", get_all_tiles())
		var tile:Tile = get_tile(global_pos)
		if(tile != null):
			print(tile.position)

func get_all_tiles() -> Array[Node]:
	pass
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
