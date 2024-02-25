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


var processors = [ColorProcessor, BasicProcessor, SelfProcessor]


var property_rules = {
	"energy": {
		"base_change": 10,
		"min": 1,
		"max": 1000
	},
	"health": {
		"base_change": 10,
		"min": 1,
		"max": 300
	},
	"speed": {
		"base_change": 10,
		"min": 50,
		"max": 500
	},
	"rotation_speed": {
		"base_change": 10,
		"min": 0,
		"max": 360
	},
	"bite_strength": {
		"base_change": 1,
		"min": 0,
		"max": 50
	},
	
	
}


func _init():

	print_debug("CreatureDNA init")


	energy = randi_range(10,200)
	health = randi_range(10,200)

	bite_strength = randi_range(1,50)

	speed = randi_range(50, 200)
	rotation_speed = randi_range(10, 180)

	offspring_energy = randi_range(10,100)
	offsprings = randi_range(1,5)

	growth_speed = randi_range(1,10)

	influence_decay.resize(Creature.Influence.size())
	for i in range(Creature.Influence.size()):
		influence_decay[i] = randi_range(0, 20)

	tile_efficiency.resize(Globals.Tile.size())
	for i in range(Globals.Tile.size()):
		tile_efficiency[i] = randf_range(0, 1)


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

		if randf() > frequency:
			mutated_dna.set(name, self.get(name))
			continue
		
		if property_rules.has(name):
			var rules = property_rules[name]
			
			var new_value = property_mutation(
					self.get(name),
					rules["base_change"]*strength,
					rules["min"],
					rules["max"],
					property["type"]
					)
					
			#print("Mutating "+name + " from: " + str(self.get(name)) + " to " + str(new_value))
			
			mutated_dna.set(name, new_value)
		elif name == "color":
			mutated_dna.color = Color(color)
		else:
			print_debug("Property: " + name + " is not mutating")
			mutated_dna.set(name, self.get(name))
	
			mutated_dna.tile_efficiency = mutate_array(tile_efficiency, 0, 1, 0.01 * strength, frequency)
			mutated_dna.influence_decay = mutate_array(influence_decay, 30, 200, 10 * strength, frequency)

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
