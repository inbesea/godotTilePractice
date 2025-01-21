extends Node2D

var new_position:Vector2
var held = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if held:
		position = get_global_mouse_position()
		

#func _input(event):
	#if event.is_action_pressed("click"):
		#held = true
	#if event.is_action_released("click"):
		#held = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	print("test")
	#if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			#held = not held
			
	if event.is_action_pressed("click"):
		held = true
	if event.is_action_released("click"):
		held = false
		new_position = get_global_mouse_position()
		
		
