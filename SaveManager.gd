extends Node

@export var save_path : String
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

func _save_thread(nodes : Array):
	
	var save = SimulationSave.new()

	for node in nodes:
		if "save" in node:
			save.active.append(node.save())
		

	save.lost_energy = EnergyManager.lostEnergy
	save.tile_energy = EnergyManager.tiles

	var map_data = Globals.rootMap.get_used_cells(0)
	for cell in map_data:
		save.rootMap[cell] = TileSave.new().save(Globals.rootMap, cell)

	map_data = Globals.mainMap.get_used_cells(0)
	for cell in map_data:
		save.mainMap[cell] = TileSave.new().save(Globals.mainMap, cell)
	
	ResourceSaver.save(save, save_path)
	
	


func save():
	
	var nodes = get_parent().get_node("Active").get_children()
	
	# var thread = Thread.new()
	# thread.start(_save_thread.bind(nodes))
	
	_save_thread(nodes)
	
	pass
	
	
func load():
	
	if !FileAccess.file_exists(save_path):
		push_error("Save File Doesn't Exists")
		return
	
	var Active = get_parent().get_node("Active")
	
	for child in Active.get_children():
		## Quite aggressive compare to queue_free, but prevents the calling of tree exiting after the map is loaded and there for the root deleting tiles that we already placed.
		child.free()


	Globals.rootMap.clear()
	Globals.mainMap.clear()
	


	var save = ResourceLoader.load(save_path) as SimulationSave

	var sd = preload("res://seed.tscn")
	var plt = preload("res://Scenes/Plants/plant.tscn")
	var cr = preload("res://Scenes/Maps/creature.tscn")


	for obj in save.active:

		var temp = load(obj.file_path).instantiate()
		temp.load(obj)

		Active.add_child(temp)

	
	for cell in save.rootMap:
		save.rootMap[cell].load(Globals.rootMap, cell) 

	for cell in save.mainMap:
		save.mainMap[cell].load(Globals.mainMap, cell) 

	
	EnergyManager.lostEnergy = save.lost_energy
	EnergyManager.tiles = save.tile_energy
	
	pass


func _input(event):
	
	if event.is_action_pressed("save"):
		
		# save_path = "res://test.tres"
		save()
		
	if event.is_action_pressed("load"):
		
		# save_path =  "res://test.tres"
		self.load()

