extends SpinBox


# Called when the node enters the scene tree for the first time.
func _ready():
	
	var line_edit = get_line_edit()
	line_edit.context_menu_enabled = false
	
	Globals.tile_energy = value
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_value_changed(value):
	
	Globals.tile_energy = value
	
	pass # Replace with function body.


func _input(event):
	
	if event.is_action_pressed("ui_accept"):
		get_line_edit().release_focus()
	
	pass # Replace with function body.
