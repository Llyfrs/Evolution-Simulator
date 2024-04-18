class_name CreatureDNA extends Resource


# Similarly to the plants, creatures will have max energy and health capacities. 
# The allow for a more complex system where the creature has a growth phase. 
@export var energy : int
@export var health : int


@export var growth_speed : int

@export var offsprings : int
@export var offspring_energy : int

@export var speed: int
@export var rotation_speed : int

## Determines damage dealt to other creatures and plants and also if the creature can eat seeds based on their durability
@export var bite_strength : int


@export var tile_efficiency : Array[float]

@export var influence_decay : Array[int]


@export var color : Color

## What sensors the creature is using
@export var sensors : Array[SensorSettings]

@export var property_variations : Dictionary

@export var generation : int 

@export var ID : int

@export var parent_ID : int

@export var parents : Array[CreatureDNA]








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
	

	## Defines the variation / deviation for the normal distribution used to mutate each property 
	property_variations = {
		"self": 0.01,
		"energy": 2,
		"health": 2,
		"growth_speed": 1,
		"offspring_energy": 2,
		"offsprings": 0.2,
		"speed": 2,
		"rotation_speed": 1,
		"bite_strength": 0.5,
		"tile_efficiency": 0.05,
		"influence_decay": 0.1,
		"color": 0.01,
		"sensors" : 0.1
	}


	pass


func proficiency_tax() -> float:
	var sum = 0
	for value in tile_efficiency:
		sum += value
	
	return pow(sum, 3)

func sensor_tax():
	return 1



func mutate():
	var mutated_dna = CreatureDNA.new()

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

			else:
				new_value = self.get(name)



			# print("Mutating "+name + " from: " + str(self.get(name)) + " to " + str(new_value))
			
			mutated_dna.set(name, new_value)

	
	mutated_dna.tile_efficiency = Mutation.FloatArray(tile_efficiency, property_variations["tile_efficiency"])
	mutated_dna.influence_decay = Mutation.IntegerArray(influence_decay, property_variations["influence_decay"])

	# mutated_dna.property_variations = Mutation.PropertyVariations(property_variations)

	mutated_dna.generation = generation + 1
	mutated_dna.parent_ID = ID
	mutated_dna.parents = parents.duplicate(true)
	mutated_dna.parents.append(self)

	return mutated_dna

