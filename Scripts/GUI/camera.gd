extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	position += direction * (delta / Engine.time_scale) * 1000
	
	if Input.is_action_just_pressed("zoom_in"): 
		zoom += Vector2(1,1)
	if Input.is_action_pressed("zoom_out"):
		zoom -= Vector2(1,1)
		
	pass
	
func _input(event : InputEvent):
	if event.is_action_pressed("zoom_in"): 
		zoom *= 1.1
	if event.is_action_pressed("zoom_out"):
		zoom *= 0.9
