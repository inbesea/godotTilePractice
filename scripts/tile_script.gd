extends Node


func get_tile_index(pos: Vector2) -> Vector2i:
	var index:Vector2i
	index.x = snapped(pos.x - 32, 64) / 64
	index.y = snapped(pos.y - 32, 64) / 64
	return index

## Returns an int representing the quadrant the point is relative to the origin. 
func get_quadrant(orgn: Vector2, pt: Vector2) -> int:
	# Should return the difference between the placed position and middle of the close tile.
	var normalPtX: float = pt.x - (orgn.x) # Divide here to get center of tile for comparison
	var normalPtY: float = pt.y - (orgn.y)

	# the point is above y = x if the y is larger than x
	var abovexEy: bool = normalPtY > normalPtX;
	# the point is above y = -x if the y is larger than the negation of x
	var aboveNxEy: bool = normalPtY > -normalPtX;

	# We can conceptualize this as four triangles converging in the center of the "closest tile"
	# We can use this framing to decide the side to place the tile.
	if (abovexEy):  # Check at halfway point of tile
		if (aboveNxEy):  # North = 0
			return 0
		else:  # West = 3
			return 3
		
	else:  # location is to the right of the closest tile
		if (aboveNxEy):  # East = 1
			return 1
		else : # South = 2
			return 2

func get_vector_of_closest_side(close_tile_vec: Vector2, drop_vector: Vector2) -> Vector2:
	var closest_opening: Vector2 = close_tile_vec
	var quad:int = get_quadrant(close_tile_vec, drop_vector)
	
	if(quad == 0):
		closest_opening.y += 64
	elif(quad == 1):
		closest_opening.x += 64
	elif(quad == 2):
		closest_opening.y -= 64
	elif(quad == 3):
		closest_opening.x -= 64
	else:
		print("Failure in tile_script")
	
	return closest_opening

func get_closest_vect(list_of_vectors: Array[Vector2], target_vector: Vector2):
	var closest_vect = list_of_vectors[0]
	for vect in list_of_vectors :
		var distance_to_vect = target_vector.distance_squared_to(vect)
		var distance_to_closest_tile = target_vector.distance_squared_to(closest_vect)
		if (distance_to_vect < distance_to_closest_tile):
			closest_vect = vect
	return closest_vect
