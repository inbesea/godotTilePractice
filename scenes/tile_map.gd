extends TileMapLayer

const Tile := preload("res://scenes/base_tile_class.tscn")
#const Tile = preload("res://scenes/base_tile_class.tscn")
#include("res://scenes/base_tile_class.tscn")
#preload("res://scenes/base_tile_class.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		
		var pos = get_global_mouse_position()
		pos.x = snapped( (pos.x - 32),64 ) / 64
		pos.y = snapped( (pos.y - 32),64 ) / 64
		set_cell(pos, 1, Vector2(0,0), 0 )
		#set_cell()
		
		print(pos)
		print("tile cell atlas id : ", get_cell_atlas_coords(pos))
		print("cell source id :", get_cell_source_id(pos))
		print("cell tile data :", get_cell_tile_data(pos))
		print("neighbors to ", pos , " : " , get_surrounding_cells(pos))
		#print("All tiles:", get_all_tiles())
		

#func get_all_tiles() -> Array[Tile]:
	#pass
	#var all_tiles:= get_tree().get_nodes_in_group("tiles") is Array[Tile]
	#return all_tiles

func get_tile(pos:Vector2):
	#var tiles = get_all_tiles()
	#for tile:Tile in tiles:
		#if tile.area.
	print("Get Tile called")
	return Tile.new() # Dummy return value

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
