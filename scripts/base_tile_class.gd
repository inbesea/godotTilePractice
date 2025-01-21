extends Node2D

var new_position:Vector2
var held = false
var indicator
@onready var ship: TileMapLayer = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		new_position = get_global_mouse_position()
		position = new_position
		indicator.position = get_new_tile_position()
		

func _on_area_2d_input_event(viewport, event, shape_idx):
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#held = not held
			
	if event.is_action_pressed("click"):
		held = true
		createIndicator()
	if event.is_action_released("click"):
		held = false
		position = indicator.position
		if indicator != null:
			indicator.queue_free()
		
		

func createIndicator():
		var scene = load("res://scenes/indicator_tile.tscn")
		indicator = scene.instantiate()
		get_node("StupidBufferNode").add_child(indicator)

func get_new_tile_position():
	#var player_input = get_global_mouse_position()
	var new_position : Vector2 = Vector2(200,200)
	# we want to get a position that gets us to a whole number. 
	# The number should be closest to the release location as possible. 

	var closest_tile:Vector2 = get_closest_tile_or_null().position
	var placement_vect = TileScript.get_vector_of_closest_side(closest_tile, get_global_mouse_position())
	#new_position = placement_vect
	print(closest_tile, " " , get_global_mouse_position())
	print("placement_vect : ",snapped(placement_vect.x,64), ",", snapped(placement_vect.y,64))
	
	#new_position.x = closest_tile.x + 64
	#new_position.y = closest_tile.y + 64
	
	new_position.x = snapped(placement_vect.x, 64)
	new_position.y = snapped(placement_vect.y, 64)
	
	return new_position

func get_closest_tile_or_null():
	var all_tiles = ship.get_tree().get_nodes_in_group("tiles")
	var closest_tile = null
		
	if (all_tiles.size() > 0):
		closest_tile = all_tiles[0]
		for tile in all_tiles:
			if tile == self:
				continue
			var distance_to_this_tile = global_position.distance_squared_to(tile.global_position)
			var distance_to_closest_tile = global_position.distance_squared_to(closest_tile.global_position)
			if (distance_to_this_tile < distance_to_closest_tile):
				closest_tile = tile

	print(closest_tile.position)
	return closest_tile

func _on_area_2d_mouse_shape_entered(shape_idx: int) -> void:
	pass # Replace with function body.
