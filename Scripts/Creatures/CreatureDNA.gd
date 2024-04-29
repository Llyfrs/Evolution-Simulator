class_name CreatureDNA extends Resource


# Similarly to the plants, creatures will have max energy and health capacities. 
# The allow for a more complex system where the creature has a growth phase. 
@export var energy : int
@export var health : int


## Defines how fast the creature is growing per second
@export var growth_speed : int


## Self explanatory, how many offsprings and how much energy they get
@export var offsprings : int
@export var offspring_energy : int


## Speed of movement, more speed costs more energy over time
@export var speed: int

## How fast the creature can rotate
@export var rotation_speed : int

## Determines damage dealt to other creatures and plants and also if the creature can eat seeds based on their durability
@export var bite_strength : int

## How efficiently can creature move around tiles, it uses the Globals.Tile enum.
## This is not the same as speed as it will not effect the energy cost if the creature is moving slowly
@export var tile_efficiency : Array[float]

## How fast the each influence category is decaying. Uses the Creature.Influence enum. 
@export var influence_decay : Array[int]


## Color of the creature, has small impact and is mostly used to visually distinguish between differed species
@export var color : Color

## What sensors the creature is using, better to look in to SensorSettings to se how it works.
@export var sensors : Array[SensorSettings]



## What generation this current DNA is, it increments it's self every time it's returned as mutated DNA
@export var generation : int 

## Unique ID of this DNA for identification in data collection
@export var ID : int

## ID of the parent, it's set when DNA is created by mutation. 
@export var parent_ID : int

## List of all parents, this is used for data collection. It should get deleted over time and not actually contain all parents but just the one that aren't recorded yet.
@export var parents : Array[CreatureDNA]



## Defines the variation / deviation for the normal distribution used to mutate each property 
static var property_variations = {
		"self": 0.01,
		"energy": 3,
		"health": 3,
		"growth_speed": 1,
		"offspring_energy": 2,
		"offsprings": 1,
		"speed": 2,
		"rotation_speed": 1,
		"bite_strength": 0.5,
		"tile_efficiency": 0.01,
		"influence_decay": 0.1,
		"color": 0.01,
		"sensors" : 0.1
	}




## Initializes the DNA with random values, the ranges were mostly chosen so that the chance of survival is not too low on random DNA
func _init():

	ID = Globals.get_ID()

	energy = randi_range(50,400)
	health = randi_range(50,400)

	bite_strength = randi_range(1,100)

	speed = randi_range(50, 400)
	rotation_speed = randi_range(10, 300)

	offspring_energy = randi_range(10,50)
	offsprings = randi_range(1,10)

	growth_speed = randi_range(1,20)
	color = Color(randf(), randf(), randf(), 1)


	influence_decay.resize(Creature.Influence.size())
	for i in range(Creature.Influence.size()):
		influence_decay[i] = randi_range(0, 20)

	tile_efficiency.resize(Globals.Tile.size())

	var total = randf_range(0.5, 3)
	var array = Globals.Tile.values().duplicate()
	array.shuffle()

	for i in array:
		tile_efficiency[i] = total * randf()
		total -= tile_efficiency[i]

	tile_efficiency[array.back()] += total
	

	for i in range(0,randi_range(4,8)):
		var sensor = SensorSettings.new()
		sensors.append(sensor)


	pass




## Returns the cost of having certain efficiency in different tile types
func proficiency_tax() -> float:

	# Having it exponential makes is more preferable to to focus just on one or two tile types instead of all of them
	var sum = 0
	for value in tile_efficiency:
		sum += value
	
	return pow(sum, 3)

func sensor_tax():
	return 1



## Returns mutated version of the current DNA
func mutate():

	# This function uses the get_property_list() method to go through all the properties and for those that have defined variation performs mutations.
	# It seemed like a good idea at the beginning because this way the DNA was easily expandable and this code didn't need changing, but it probably introduces more problems
	# that just doing the same thing that I do in _init()


	var mutated_dna = CreatureDNA.new()
	mutated_dna.sensors.clear()

	for sensor in sensors:
		mutated_dna.sensors.append(sensor.mutate())

	var roll = randfn(0, 1)
	if roll > 2:
		mutated_dna.sensors.append(SensorSettings.new())
	
	if roll < -2:
		if mutated_dna.sensors.size() > 1:
			mutated_dna.sensors.remove_at(randi() % mutated_dna.sensors.size())

	for property in mutated_dna.get_property_list():
		var name = property["name"]

		if property_variations.has(name):
			var new_value;

			if property["type"] == TYPE_INT:
				new_value = Mutation.Integer(self.get(name), property_variations[name])

			elif property["type"] == TYPE_FLOAT:
				new_value = Mutation.Float(self.get(name), property_variations[name])
			elif name == "color":
				new_value = Mutation.Color(self.get(name), property_variations[name])
				# print("Mutating color " + str(color) + " to " + str(mutated_dna.color))
			elif name == "sensors":
				pass

			else:
				new_value = self.get(name)
			
			mutated_dna.set(name, new_value)

	
	mutated_dna.tile_efficiency = Mutation.FloatArray(tile_efficiency, property_variations["tile_efficiency"])
	mutated_dna.influence_decay = Mutation.IntegerArray(influence_decay, property_variations["influence_decay"])

	# mutated_dna.property_variations = Mutation.PropertyVariations(property_variations)

	mutated_dna.generation = generation + 1
	mutated_dna.parent_ID = ID
	mutated_dna.parents = parents.duplicate(true)
	mutated_dna.parents.append(self)
	

	return mutated_dna

