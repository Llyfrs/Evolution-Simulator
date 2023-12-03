extends Node

var tiles  : Dictionary
var plants : Array[Plant]
var seeds : Array[Seed]

var mutex : Mutex = Mutex.new()



var lostEnergy : float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


## Subscribe seed or plant to the energy manager
## This will make it part of the loop where energy is calculated
func subscribe(sub : Object):
	mutex.lock()
	if sub is Plant:
		plants.append(sub)
	if sub is Seed:
		seeds.append(sub)
	mutex.unlock()


## Unsubscribe seed or plant from the energy manager 
func unsubscribe(sub : Object):
	mutex.lock()
	if sub is Plant:
		plants.erase(sub)
	if sub is Seed:
		seeds.erase(sub)
	pass
	mutex.unlock()
	

func seed_worker(seed_index, delta):
	for sd in seeds:
		var degrade = 1 * delta
		var leftover = sd.remove_energy(degrade)
		
		add_energy(sd.get_tile(), degrade - leftover)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	
	for sd in seeds:
		var degrade = 1 * delta
		var leftover = sd.remove_energy(degrade)
		
		add_energy(sd.get_tile(), degrade - leftover)

	
	
	# Holds total for presence 
	var list = Dictionary()
	var lock_energy = Dictionary()
	
	# Creates dictionary where key is the tile cords and 
	# value is total number of roots from all plants
	for plant in plants:
		var presence = plant.root.get_tilemap_presence(plant.map, plant.dna)
		
		for key in presence: 
			if list.has(key):
				list[key] += presence[key]
				
			else:
				list[key] = presence[key]  
				lock_energy[key] = get_energy(key)
				
	for plant in plants:
		var presence = plant.root.get_tilemap_presence(plant.map, plant.dna)
		for key in presence: 
			var energy = 0
			if list[key] * delta <= get_energy(key):
				energy = presence[key] * delta
			else : 
				var ration : float = presence[key] / float(list[key])
				energy = lock_energy[key] * ration
			set_energy(key, get_energy(key) - energy + plant.add_energy(energy))
	
	
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
		tiles[location] = 100
		return tiles[location]


## Set energy for a specific tile, this is not adding energy but rewrtiting the current value
## If the tile doesn't exits it results in error. 
func set_energy(location : Vector2, energy : float):
	location = Vector2i(location)
	tiles[location] = energy

	if energy < -0.0001:
		print("Energy can't be negative: " + str(energy))
		tiles[location] = 0
	


func add_energy(location: Vector2i, energy: float):
	set_energy(location, get_energy(location) + energy)
## Gives every tile in the map a energy value of 100, good for easy start and making sure everything is trackable
## but is not nessecery for the EnergyManager to run
func init_map(map : TileMap):
	for cell in map.get_used_cells(0):
		set_energy(cell, 100)

	print(get_total_energy())
	
	
	pass 


## Adds lost energy to the total lost, this value them will be redistributed to the system
func add_lost_energy(energy : float):
	lostEnergy += energy
