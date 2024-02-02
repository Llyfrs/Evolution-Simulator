extends Node

@export var save_file : String
# Called when the node enters the scene tree for the first time.


func _enter_tree():
	GlobalMaps.mainMap = $Active/map_1/TileMap
	GlobalMaps.rootMap = $Active/map_1/RootMap

func _ready():
	
	print("Main")
	
	#var plant_sceen = load("res://Scenes/Plants/plant.tscn") as PackedScene
	Engine.time_scale = 5
	EnergyManager.init_map($Active/map_1/TileMap)
	
	
		
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	## print(EnergyManager.get_total_energy())
	pass


func _input(event):
	if event.is_action_pressed("ui_left_mouse_button"):
		var position = GlobalMaps.mainMap.get_local_mouse_position() as Vector2
		position = GlobalMaps.mainMap.local_to_map(position)
		print(EnergyManager.get_energy(position))
	
	if event.is_action_pressed("speed_up"):
		Engine.time_scale += 1
		print("Changing speed to: " + str(Engine.time_scale) + "x")
	if event.is_action_pressed("speed_down"):
		if Engine.time_scale > 1:
			Engine.time_scale -= 1
		print("Changing speed to: " + str(Engine.time_scale) + "x")
		
	if event.is_action_pressed("save"):

		var nodes = $Active.get_children()

		for node in nodes:
			
			var test = inst_to_dict(node)
			print(test)
			print("\n\n--------\n\n")
			# var copy = dict_to_inst(test)
			# $Active.add_child(copy)

		pass


		
	if event.is_action("load"):


		var scene = load("res://my_scene.tscn") as PackedScene
		
		var instance = scene.instantiate()

		for child in instance.get_children():
			print(child.name)
		


		pass

