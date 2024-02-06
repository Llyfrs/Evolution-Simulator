extends Node

@export var save_file : String
# Called when the node enters the scene tree for the first time.



# Enter tree gets called in order from root to leaf, making sure that the maps are loaded before
# other objects that depend on them request them.
func _enter_tree():
	GlobalMaps.mainMap = $Map/TileMap
	GlobalMaps.rootMap = $Map/RootMap



func _ready():
	
	print("Main")
	
	#var plant_sceen = load("res://Scenes/Plants/plant.tscn") as PackedScene
	Engine.time_scale = 5
	EnergyManager.init_map(GlobalMaps.mainMap)
	
	
		
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

		var save = SimulationSave.new()


		var nodes = $Active.get_children()

		for node in nodes:
			if "save" in node:
				save.active.append(node.save())
				
		
		save.lost_energy = EnergyManager.lostEnergy
		save.tile_energy = EnergyManager.tiles

		var map_data = GlobalMaps.rootMap.get_used_cells(0)
		for cell in map_data:
			save.rootMap[cell] = TileSave.new().save(GlobalMaps.rootMap, cell)

		map_data = GlobalMaps.mainMap.get_used_cells(0)
		for cell in map_data:
			save.mainMap[cell] = TileSave.new().save(GlobalMaps.mainMap, cell)
			
			
			
		ResourceSaver.save(save, "res://test.tres")

		pass


		
	if event.is_action("load"):
		for child in $Active.get_children():
			## Quite aggressive compare to queue_free, but prevents the calling of tree exiting after the map is loaded and there for the root deleting tiles that we already placed.
			child.free()


		GlobalMaps.rootMap.clear()
		GlobalMaps.mainMap.clear()

		var save = ResourceLoader.load("res://test.tres", "SimulationSave") as SimulationSave

		var sd = preload("res://seed.tscn")
		var plt = preload("res://Scenes/Plants/plant.tscn")

		for obj in save.active:

			if obj is PlantSave:
				var temp_plant = plt.instantiate()
				temp_plant.load(obj)

				$Active.add_child(temp_plant)

			if obj is SeedSave:
				var temp_seed = sd.instantiate()
				temp_seed.load(obj)

				$Active.add_child(temp_seed)

		
		for cell in save.rootMap:
			save.rootMap[cell].load(GlobalMaps.rootMap, cell) 

		for cell in save.mainMap:
			save.mainMap[cell].load(GlobalMaps.mainMap, cell) 

		
		EnergyManager.lostEnergy = save.lost_energy
		EnergyManager.tiles = save.tile_energy
		
		pass

