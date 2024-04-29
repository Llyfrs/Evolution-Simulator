extends Node

"""

This entire script is "I have variable here and I need it there" so there is ton of code but not much to explain.
The save function and collect data function are connected to a timer so they are triggered automatically.

"""


@export var save_path : String

var creature_save
var plant_save
var simulation_save
var collect_data : bool = false


var saved_dna = []

var ignore = ["health", "energy", "pos", "rot", "file_path", "vel"]

## Structure to make it more straight forward when saving data about simulation
class SimulationData:
	var total_energy : float
	var lost_energy : float
	var creatures : int
	var plants : int
	var seeds : int
	var plant_highest_generation : int
	var creature_highest_generation : int
	var plant_highest_generation_current : int
	var creature_highest_generation_current : int

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.save_manager = self
	
	
	if !collect_data:
		return
	
	creature_save = save_path.trim_suffix(".tres") + "_creatures.csv"
	plant_save = save_path.trim_suffix(".tres") + "_plants.csv"
	simulation_save = save_path.trim_suffix(".tres") + "_simulation.csv"
	
	if !FileAccess.file_exists(creature_save):
		var test = CreatureSave.new()
		test.dna = CreatureDNA.new()
		var line = PackedStringArray()
		
		var file = FileAccess.open(creature_save, FileAccess.WRITE)

		for property in test.dna.get_property_list():
			if property["usage"] == 4102 and property["class_name"] == "" and property["name"] != "parents" and property["name"] != "property_variations":
				line.append(property["name"])

		file.store_csv_line(line)
		file.close()
	
	if !FileAccess.file_exists(plant_save):
		var test = PlantSave.new()
		test.dna = PlantDNA.new()
		var line = PackedStringArray()
		
		var file = FileAccess.open(plant_save, FileAccess.WRITE)

		for property in test.dna.get_property_list():
			if property["usage"] == 4102 and property["class_name"] == "" and property["name"] != "parents" and property["name"] != "property_variations":
				line.append(property["name"]) 

		file.store_csv_line(line)
		file.close()
	
	if !FileAccess.file_exists(simulation_save):
		var test = SimulationData.new()
		
		var file = FileAccess.open(simulation_save, FileAccess.WRITE)
		var line = PackedStringArray()


		for property in test.get_property_list():
			if property["usage"] == 4096 and property["class_name"] == "":
				line.append(property["name"])

		file.store_csv_line(line)
		file.close()


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
	save.max_creature_generation = EnergyManager.max_creature_generation
	save.max_plant_generation = EnergyManager.max_plant_generation
	
	save.generated_IDs = Globals.used_IDs
	save.saved_creatures = Globals.saved_creatures
	save.saved_plants = Globals.saved_plants

	save.recorded_dna = saved_dna
	save.data_collection = collect_data


	var map_data = Globals.rootMap.get_used_cells(0)
	for cell in map_data:
		save.rootMap[cell] = TileSave.new().save(Globals.rootMap, cell)

	map_data = Globals.mainMap.get_used_cells(0)
	for cell in map_data:
		save.mainMap[cell] = TileSave.new().save(Globals.mainMap, cell)
	
	ResourceSaver.save(save, save_path)
	
	


func save():
	var nodes = get_parent().get_node("Active").get_children().duplicate(true)
	
	_save_thread(nodes)
	
	pass
	
	
func load():
	
	if !FileAccess.file_exists(save_path):
		push_error("Save File " + save_path + " Doesn't Exists")
		return
	
	var Active = get_parent().get_node("Active")
	
	for child in Active.get_children():
		## Quite aggressive compare to queue_free, but prevents the calling of tree exiting after the map is loaded 
		## and there for the root deleting tiles that we already placed.
		child.free()


	Globals.rootMap.clear()
	Globals.mainMap.clear()
	
	var save = ResourceLoader.load(save_path) as SimulationSave

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
	EnergyManager.max_creature_generation = save.max_creature_generation
	EnergyManager.max_plant_generation = save.max_plant_generation

	Globals.used_IDs = save.generated_IDs
	Globals.saved_creatures = save.saved_creatures
	Globals.saved_plants = save.saved_plants

	
	collect_data = save.data_collection
	saved_dna = save.recorded_dna

	pass


func _input(event):
	
	if event.is_action_pressed("save"):		
		# save_path = "res://test.tres"
		save()
		
				# Way to mannualy take screen shot of current creatures
		for plant in EnergyManager.plants:
			record_plant(plant)
			
		for creature in EnergyManager.creatures:
			record_creature(creature)
		
		
	if event.is_action_pressed("load"):
		
		# save_path =  "res://test.tres"
		self.load()



func record_creature(creature : Creature):
	var sv = creature.save()
	save_dna(sv, creature_save)


func record_plant(plant : Plant):
	var sv = plant.save()
	save_dna(sv, plant_save)

	pass


func save_dna(sv, path):
	
	if !collect_data:
		return
	

	var file = FileAccess.open(path, FileAccess.READ_WRITE)
	file.seek_end()

	var history = sv.dna.parents.duplicate()
	history.append(sv.dna)
	
	sv.dna.parents.clear()

	for dna in history:
		
		var line = PackedStringArray()

		if saved_dna.has(dna.ID):
			continue
		
		for property in dna.get_property_list():
			if property["usage"] == 4102 and property["class_name"] == "" and property["name"] != "parents" and property["name"] != "property_variations":
				saved_dna.append(dna.ID)
				line.append( str(dna.get(property["name"])) )
				
		file.store_csv_line( line )

	file.close()


func record(node):
	
	if node is Creature:
		record_creature(node)
	
	if node is Plant:
		record_plant(node)
	

func valid_property(property):
	if property["usage"] == 4102 and property["class_name"] == "" and !ignore.has(property["name"]):
		return true
	else:
		return false


func _on_data_colection_timeout():
	
	if !collect_data:
		return
	
	var save = SimulationData.new()

	save.total_energy = EnergyManager.get_total_energy()
	save.lost_energy = EnergyManager.lostEnergy
	save.creatures = EnergyManager.creatures.size()
	save.plants = EnergyManager.plants.size()
	save.seeds = EnergyManager.seeds.size()
	save.plant_highest_generation = EnergyManager.max_plant_generation
	save.creature_highest_generation = EnergyManager.max_creature_generation

	var max_plant = 0
	var max_creature = 0

	for creature in EnergyManager.creatures:
		if creature.dna.generation > max_creature:
			max_creature = creature.dna.generation

	for plant in EnergyManager.plants:
		if plant.dna.generation > max_plant:
			max_plant = plant.dna.generation

	save.plant_highest_generation_current = max_plant
	save.creature_highest_generation_current = max_creature


	var file = FileAccess.open(simulation_save, FileAccess.READ_WRITE)
	file.seek_end()

	var line = PackedStringArray()

	for property in save.get_property_list():
		if property["usage"] == 4096 and property["class_name"] == "":
			line.append( str(save.get(property["name"])) )

	file.store_csv_line( line )
	file.close()

	pass 
