extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _physics_process(delta):
	# Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("left", "right")
	var ydirection = Input.get_axis("up", "down")
	
	var dir : Vector2 = Vector2(direction, ydirection)
	# Fix weird diagonal movement
	dir = dir.normalized()
	
	if dir.x:
		velocity.x = dir.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	if dir.y:
		velocity.y = dir.y * SPEED
	else:
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
