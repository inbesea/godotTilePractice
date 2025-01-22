extends Camera2D

@onready var new_pos = position
var lerp : float = 0.005
var outside:bool = false
var zoom_amt:float = 0.02

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#pass
	if outside:
		new_pos = get_global_mouse_position()
		
		position.x -= (position.x - new_pos.x) * lerp
		position.y -= (position.y - new_pos.y) * lerp

func _input(event):
	if event.is_action("scroll_up"):
		zoom.x += zoom_amt
		zoom.y += zoom_amt
	if event.is_action("scroll_down"):
		zoom.x -= zoom_amt
		zoom.y -= zoom_amt
	pass

func _on_area_2d_mouse_exited() -> void:
	outside = true
	#new_pos = get_global_mouse_position()


func _on_area_2d_mouse_entered() -> void:
	outside = false
	new_pos = position
