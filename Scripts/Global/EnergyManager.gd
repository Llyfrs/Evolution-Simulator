extends Node


"""

This class is loaded globally by godot and the _process function is called every frame. It's job is to redistribute lost energy, and calculate 
how much energy should each plant receive based on it¨s number of roots. It also holds some good information about the simulation and it triggers saves
when it detects new highest generation. 

"""


## Energy for each existing tile 
var tiles  : Dictionary

## All energy that was lost and needs to be redistributed
var lostEnergy : float = 0


var plants : Array[Plant] 
var seeds : Array[Seed]
var creatures : Array[Creature]

## Seeds exist in their own thread and when subscribing the would break the program. This mutex prevents that.
var mutex : Mutex = Mutex.new()

var max_creature_generation = 0
var max_plant_generation = 0

var redistribution_amount = 100
var redistribution_percentage = 0.5

var redistribution = [1, 1, 1, 1]


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Subscribe seed or plant to the energy manager
## This will make it part of the loop where energy is calculated
func subscribe(sub : Object):
	mutex.lock()
	if sub is Plant:

		if max_plant_generation < sub.dna.generation:
			max_plant_generation = sub.dna.generation
			Globals.save_manager.record(sub)



		plants.append(sub)
	if sub is Seed:
		seeds.append(sub)
	if sub is Creature:
		if max_creature_generation < sub.dna.generation:
			max_creature_generation = sub.dna.generation
			Globals.save_manager.record(sub)


		creatures.append(sub)
	mutex.unlock()


## Unsubscribe seed or plant from the energy manager 
func unsubscribe(sub : Object):
	mutex.lock()
	if sub is Plant:
		plants.erase(sub)
	if sub is Seed:
		seeds.erase(sub)
	if sub is Creature:
		creatures.erase(sub)
	pass
	mutex.unlock()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	# Holds total for presence 
	var list = Dictionary()
	var lock_energy = Dictionary()
	
	# Creates dictionary where key is the tile cords and 
	# value is total number of roots from all plants
	for plant in plants:
		var presence = plant.root.get_tilemap_presence(Globals.mainMap, plant.dna)
		
		for key in presence: 
			if list.has(key):
				list[key] += presence[key]
				
			else:
				list[key] = presence[key]  
				lock_energy[key] = get_energy(key)
				
	for plant in plants:
		var presence = plant.root.get_tilemap_presence(Globals.mainMap, plant.dna)
		for key in presence: 
			var energy = 0
			if list[key] * delta <= get_energy(key):
				energy = presence[key] * delta
			else : 
				var ration : float = presence[key] / float(list[key])
				energy = lock_energy[key] * ration
			add_energy(key, -energy + plant.add_energy(energy))
	
	

	if lostEnergy < redistribution_amount:
		return;

	var total = redistribution.reduce(func (a, b): return a + b, 0)
	var ration = redistribution.map(func (a : float): return a / total)


	var energy = redistribution_amount as float / tiles.size() 
	for cords in tiles:
		
		var types = Globals.get_tile_type(cords)

		if types.is_empty():
			continue

		if ration[types[0]] > randf():
			add_energy(cords, energy)
			lostEnergy -= energy
			continue

	pass


## Returns total amount of energy in the world, including all subscribed plants and seeds 
## If this value stays stable it means that no energy is being added or lost in the system
func get_total_energy() -> float:
	var total = 0
	for plant in plants:
		total += plant.energy
		total += plant.health

	for sd in seeds:
		total += sd.energy

	for cr in creatures:
		total += cr.energy
		total += cr.health


	for key in tiles:
		total += tiles[key]
	
	return total + lostEnergy


## Returns total amount of entities in the world, including all subscribed plants and seeds
func get_total_entities() -> int:
	return plants.size() + seeds.size()



## Gets energy from a location or set's it to 100 if the location wasn't loaded yet
## NOTE: REWRITE not a good place to have a static value in the future. 
func get_energy(location : Vector2):
	location = Vector2i(location)
	if tiles.has(location):
		return tiles[location]
	else:
		return 0
		

		
## Set energy for a specific tile, this is not adding energy but rewrtiting the current value
## If the tile doesn't exits it results in error. 
func set_energy(location : Vector2, energy : float):
	location = Vector2i(location)
	tiles[location] = energy

	if energy < -0.0001:
		print("Energy can't be negative: " + str(energy))
		tiles[location] = 0
	



func add_energy(location: Vector2, energy: float):
	location = Vector2i(location)
	if tiles.has(location):
		mutex.lock()
		tiles[location] += energy
		mutex.unlock()
	else:
		add_lost_energy(energy)
		



## Gives every tile in the map a energy value of 100, good for easy start and making sure everything is trackable
## but is not nessecery for the EnergyManager to run
func init_map(map : TileMap):
	for cell in map.get_used_cells(0):
		
		var data = Globals.mainMap.get_cell_atlas_coords(0, cell)
		if data == Globals.WALL_TILE:
			continue
			
		set_energy(cell, 300)

	print(get_total_energy())
	
	
	pass 


## Adds lost energy to the total lost, this value them will be redistributed to the system
func add_lost_energy(energy : float):
	mutex.lock()
	lostEnergy += energy
	mutex.unlock()
	

func print_tiles():

	print("---------------------")
	for key in tiles:
		print(str(key) + ": " + str(tiles[key]))


func is_limited(type):

	if type == Limits.CREATURE:
		return creatures.size() >= Limits.limits[Limits.CREATURE]

	if type == Limits.PLANT:
		return plants.size() >= Limits.limits[Limits.PLANT]

	if type == Limits.SEED:
		return seeds.size() >= Limits.limits[Limits.SEED]
