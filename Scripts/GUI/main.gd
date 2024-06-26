extends Node


"""

This is script for a the main node in the simulation scene. This means it's the first to enter the tree and last ot be ready. 
It used to do more but now it just makes sure everything that needs to work works and allows user to control the speed of the simulation.

"""


@export var save_file : String
# Called when the node enters the scene tree for the first time.



# Enter tree gets called in order from root to leaf, making sure that the maps are loaded before
# other objects that depend on them request them.
func _enter_tree():
	Globals.mainMap = $Map/TileMap
	Globals.rootMap = $Map/RootMap
	
	
	## For debuging from the godot editor, when the main scene is run straight up and not from the MainMenu Scene
	if $SaveManager.save_path == "":
		$SaveManager.save_path = "user://debug_save.tres"
	


func _ready():
	print("Main")
	
	#var plant_sceen = load("res://Scenes/Plants/plant.tscn") as PackedScne
	Engine.time_scale = 1
	EnergyManager.init_map(Globals.mainMap)
	
	pass # Replace with function body.

func _input(event):
	
	if event.is_action_pressed("ui_left_mouse_button") and Globals.cursor == Globals.CursorMode.SELECT:
		var position = Globals.mainMap.get_local_mouse_position() as Vector2
		position = Globals.mainMap.local_to_map(position)
		print(EnergyManager.get_energy(position))
	
	if event.is_action_pressed("speed_up"):
		if Engine.time_scale < 1:
			Engine.time_scale = 1
		else:
			Engine.time_scale += 1
	if event.is_action_pressed("speed_down"):
		if Engine.time_scale > 1:
			Engine.time_scale -= 1
		else:
			Engine.time_scale /= 2
			
	if event.is_action_pressed("ui_cancel"):
		$CanvasLayer/PauseMenu.visible = true
		get_tree().paused = true



