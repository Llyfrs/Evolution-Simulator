extends Node

@export var save_file : String
# Called when the node enters the scene tree for the first time.



# Enter tree gets called in order from root to leaf, making sure that the maps are loaded before
# other objects that depend on them request them.
func _enter_tree():
	Globals.mainMap = $Map/TileMap
	Globals.rootMap = $Map/RootMap
	
	if $SaveManager.save_path == "":
		$SaveManager.save_path = "res://test.tres"
	




func _ready():
	
	print("Main")
	
	#var plant_sceen = load("res://Scenes/Plants/plant.tscn") as PackedScene
	Engine.time_scale = 1
	EnergyManager.init_map(Globals.mainMap)
	


	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("ui_left_mouse_button") and Globals.cursor == Globals.CursorMode.SELECT:
		var position = Globals.mainMap.get_local_mouse_position() as Vector2
		position = Globals.mainMap.local_to_map(position)
		print(EnergyManager.get_energy(position))
	
	if event.is_action_pressed("speed_up"):
		Engine.time_scale += 1
		print("Changing speed to: " + str(Engine.time_scale) + "x")
	if event.is_action_pressed("speed_down"):
		if Engine.time_scale > 1:
			Engine.time_scale -= 1
		print("Changing speed to: " + str(Engine.time_scale) + "x")




