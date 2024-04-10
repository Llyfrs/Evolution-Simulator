class_name PlantDNA extends Resource


@export var energy_consumption : int

# How faraway from the source should the next active root be used
# 0 - the closest 
# 1 - the furthest
@export var root_distance_from_source : float # 0-1

# Form of context free grammar, can result in basically any pattern
# but most of them are going to be bad, that's where natural selection kicks in
@export var root_pattern : Array[Array]

# At what energy level should energy be spend to grow more root
@export var root_grow_threshold: int 
# How effective are roots at picking up energy frome tiles, also deternimes 
# root grow cost
@export var root_effectivnes : float

# How much energy can plant store, determines when it's ready to reproduce
@export var energy : int

# Determines grow state of the plant in extension to determining it's current health
# To defend it's self from animals
@export var health : int 


# How quickly does the plant grow (HP)
@export var plant_grow_speed: float

# Determines amount of seeds
@export var seed_quantity : int


# Controls where the seed is going to be released
@export var seed_direction : float
@export var seed_spread : float
@export var seed_distance : int

# Statistics for the seed 
@export var seed_nutrition : int
@export var seed_durability : int 

@export var color : Color


var property_variations



func _init():
	
	root_pattern = generate_random_pattern(5, 3, 2)
	color = Color(randf(), randf(), randf())

	energy = randi_range(20, 200)
	health = randi_range(20,200)
	root_effectivnes =  randf_range(0, 10)
	root_grow_threshold = randi_range(20, 200)
	root_distance_from_source = randf()
	plant_grow_speed = randf_range(0.1, 5)
	seed_quantity = randi_range(1, 10)
	seed_nutrition = randi_range(0,50)
	seed_durability = randi_range(0,50)
	seed_direction = randf_range(0, (PI * 2))
	seed_spread = randf_range(0, (PI * 2))
	seed_distance = randi_range(0, 300)

	property_variations = {
	"self" : 0.01,
	"energy": 3,
	"health": 3,
	"root_effectivnes": 0.05,
	"root_grow_threshold": 3 ,
	"root_distance_from_source": 2,
	"plant_grow_speed": 0.1 , 
	"seed_quantity": 0.5, 
	"seed_nutrition" : 1,
	"seed_durability" : 0.5,
	"seed_direction" : 0.043, 
	"seed_spread" : 0.043, 
	"seed_distance" : 3, 
	"color" : 0.4,
	"root_pattern" : 1
	}
	

	pass

## Generates pattern 
## mutables is how many variables are there going to be, 
## options, is how max many rules can be assigned to specific variable
## emptiness increases chance for rule to contain empty cell, this is good to prevent
## to many patterns that are just big solid mass
func generate_random_pattern(mutables : int, options : int, emptines : float = 0.1):
	var pattern : Array[Array] = []
	pattern.resize(mutables)
	
	var choices = range(-1, mutables)
	
	for i in range(mutables * emptines):
		choices.push_back(-1)
	
	for i in range(mutables):
		for j in range(randi_range(0, options)):
			pattern[i].append([choices.pick_random(), choices.pick_random(), choices.pick_random(), choices.pick_random()])
			
	return pattern
	


## Returns new mutated DNA
## Frequency is how often should mutation happen per property. Should be value between 0 and 1.
## Strength is how big should the mutation be.
## Value of 1 means that the mutation is going to use the default mutation rules, 
## any other value is going to multiply the base mutation value. 
func mutate(_frequency : float, _strength : float):
	var mutated_dna = CreatureDNA.new()

	for property in mutated_dna.get_property_list():
		var name = property["name"]

		if property_variations.has(name):
			var new_value;

			if property["type"] == TYPE_INT:
				new_value = Mutation.Integer(self.get(name), property_variations[name])

			elif property["type"] == TYPE_FLOAT:
				new_value = Mutation.Float(self.get(name), property_variations[name])

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
	

	property_variations = Mutation.PropertyVariations(property_variations)

	return mutated_dna


## Mutates the pattern, right now the number of rules and number of cells in each rule stays the same
## NOTE: I want the size to chage 
func mutate_pattern(frequency : float):
	# Rules cannot be removed as that completely changes the pattern and would need every 
	# reference to that rule to be changed


	var new_pattern = []
	# Mutates already existing rules
	for rule in root_pattern:
		if randf() < frequency:
			new_pattern.append(rule)
			continue
		
		var new_rule = []
		for cell in rule:
			
			## Chance to add a new cell needs to be before the chance to remove cell
			## because if the cell is removed the chance to add new cell is going to be 0
			
			## Chance to add new cell
			if randf() < frequency/cell.size():
				var gnr_cell = generate_new_cell(root_pattern.size())
				new_rule.append(gnr_cell)
				#print("Adding cell")
							
			
			## Chance to remove cell
			if randf() < frequency/cell.size():
				#print("Removing cell")
				continue
			

			## Mutatting already existing cells 
			var new_cell = []
			for i in range(4):
				if randf() < frequency:
					new_cell.append(cell[i])
					continue
				new_cell.append(randi_range(-1, root_pattern.size()-1))
				
			new_rule.append(new_cell)

		
		new_pattern.append(new_rule)

	# print( "Old pattern: ")
	# MyTools.print_patten(root_pattern)
	# print( "New pattern: ")
	# MyTools.print_patten(new_pattern)

	return new_pattern


func generate_new_cell(rules_size: int):
	var cell = []
	for i in range(4):
		cell.append(randi_range(-1, rules_size-1))
	return cell


func _to_string():
	var string = ""

	for property in get_property_list():
		var name = property["name"]
		string += name + ": " + str(self.get(name)) + "\n"

	return string


