extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	#var plant_sceen = load("res://Scenes/Plants/plant.tscn") as PackedScene
	Engine.time_scale = 5
	EnergyManager.init_map($map_1/TileMap)
	
#	for i in range(5000):
#		var plant = plant_sceen.instantiate() as Plant
#		plant.map = $map_1/TileMap
#		add_child(plant)
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	## print(EnergyManager.get_total_energy())
	pass


func _input(event):
	if event.is_action_pressed("ui_left_mouse_button"):
		var position = $map_1/TileMap.get_local_mouse_position() as Vector2
		position = $map_1/TileMap.local_to_map(position)
		print(EnergyManager.get_energy(position))
	
	if event.is_action_pressed("speed_up"):
		Engine.time_scale += 1
		print("Changing speed to: " + str(Engine.time_scale) + "x")
	if event.is_action_pressed("speed_down"):
		if Engine.time_scale > 1:
			Engine.time_scale -= 1
		print("Changing speed to: " + str(Engine.time_scale) + "x")
		
