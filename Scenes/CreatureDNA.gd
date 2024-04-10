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


@export var tile_efficiency : Array

@export var influence_decay : Array


@export var color : Color

## What sensors the creature is using
@export var sensors : Array[SensorSettings]


var processors = [ColorProcessor, BasicProcessor, SelfProcessor, TileTypeProcessor]


var property_rules = {
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
	"color": 0.4,
	"sensors" : 0.1
}


func _init():

	energy = randi_range(10,200)
	health = randi_range(10,200)

	bite_strength = randi_range(1,50)

	speed = randi_range(50, 200)
	rotation_speed = randi_range(10, 180)

	offspring_energy = randi_range(10,100)
	offsprings = randi_range(1,5)

	growth_speed = randi_range(1,10)
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
	

	for i in range(0,randi_range(2,5)):
		var sensor = SensorSettings.new()

		## The processor will be randomly generate in it's own _init function. 
		## that way we don't have to worry about what processor was chosen.
		sensor.processor = processors[randi() % processors.size()].new()
		sensor.receiver = Creature.Influence.values().pick_random()

		sensor.range = randi_range(50,300)
		sensor.angle = randf_range(0, 2 * PI)

		sensor.influence = randi_range(30,60)

		sensors.append(sensor)
	


	pass


func proficiency_tax() -> float:
	var sum = 0
	for value in tile_efficiency:
		sum += value
	
	return pow(sum, 3)

func sensor_tax():
	return 1



func mutate(frequency : float, strength : float):
	var mutated_dna = CreatureDNA.new()

	for sensor in sensors:
		mutated_dna.sensors.append(sensor.mutate(frequency, strength))

	for property in mutated_dna.get_property_list():
		var name = property["name"]

		if property_rules.has(name):
			var new_value;

			if property["type"] == TYPE_INT:
				new_value = Mutation.Integer(self.get(name), property_rules[name])

			elif property["type"] == TYPE_FLOAT:
				new_value = Mutation.Float(self.get(name), property_rules[name])

			else:
				new_value = self.get(name)



			# print("Mutating "+name + " from: " + str(self.get(name)) + " to " + str(new_value))
			
			mutated_dna.set(name, new_value)
		elif name == "color":
			mutated_dna.color = Mutation.Color(self.get(name), 1)
			# print("Mutating color " + str(color) + " to " + str(mutated_dna.color))
		else:
			print("Property: " + name + " is not mutating")
			mutated_dna.set(name, self.get(name))
	
	mutated_dna.tile_efficiency = Mutation.FloatArray(tile_efficiency, property_rules["tile_efficiency"])
	mutated_dna.influence_decay = Mutation.IntegerArray(influence_decay, property_rules["influence_decay"])

	return mutated_dna




func property_mutation(current, change ,maximum, minimum, type = 2):
	# Rolls dice on if the mutation should even happen
	
	var mutation = 0
	if type == 2:
		change = ceil(change)
		mutation = clamp(current - randi_range(-change, change), minimum, maximum)
	if type == 3:
		mutation = clamp(current - randf_range(-change, change), minimum, maximum)
	
	return current + mutation


@warning_ignore("SHADOWED_GLOBAL_IDENTIFIER")
func mutate_array(array, max, min, change, frequency):

	var new_array = []
	for value in array:


		if randf() < frequency:
			new_array.append(clamp(value - randf_range(-change, change), min, max))
		else:
			new_array.append(value)
	

	return new_array




