class_name Mutation

"""

This class contains all the functions that are used to mutate different values around the program. The use the normal distribution function randfn(). 

"""


static func Integer(value : int, variation: float):
	return max(0, roundi(value + randfn(0, variation)))


static func Float(value : float, variation: float):
	return max(0, value + randfn(0, variation))


static func FloatArray(array : Array[float], variation: float):
	var mutated_array :Array[float] = []

	for value in array:
		mutated_array.append(Float(value, variation))
	
	return mutated_array


static func IntegerArray(array : Array[int], variation: float):
	var mutated_array : Array[int] = []

	for value in array:
		mutated_array.append(Integer(value, variation))
	
	return mutated_array



static func Color(color : Color, variation: float):
	return Color(
		min(Float(color.r, variation), 1),
		min(Float(color.g, variation), 1),
		min(Float(color.b, variation), 1)
	)


static func PropertyVariations(variations : Dictionary):

	var global = variations.get("self", 0)
	var new_variations = {}

	for key in variations.keys(): 
		new_variations[key] = Float(variations[key], global)
		# print("Mutating: " + str(key) + " from " + str(variations[key]) + " to " + str(new_variations[key]))

	return new_variations


static func generate_new_cell(rules_size: int):
	var cell = []
	for i in range(4):
		cell.append(randi_range(-1, rules_size-1))
	return cell


static func Pattern(pattern : Array, variation : float):

	"""
	
	This is long and convoluted function, but it is only removing or adding rules
	and then changing references to them accordingly. This is the result of the format
	I decided to represent the pattern as. While here annoying in other parts of the code
	the format is useful. 
	
	"""
	
	
	var new_pattern = []
	var change_up = []
	var change_down = []

	# Changes or removes rules at random. 
	for rule in range(pattern.size()):
		var roll = randfn(0, variation)
		new_pattern.append(pattern[rule].duplicate(true))
	

		if roll > 2:
			change_up.append(rule)
			new_pattern.append([])
		
		if roll < -2:
			change_down.append(rule)
			new_pattern.pop_back()
		
	

	# Changes references to rules 		
	for change in change_down:
		for i in range(new_pattern.size()):
			for j in range(new_pattern[i].size()):
				for k in range(4):
					
					if new_pattern[i][j][k] == change:
						new_pattern[i][j][k] = -1

	# Changes references to rules 		
	for change in change_down:
		for i in range(new_pattern.size()):
			for j in range(new_pattern[i].size()):
				for k in range(4):
					
					if new_pattern[i][j][k] > change:
						new_pattern[i][j][k] -= 1

		for index in range(change_up.size()):
			if change_up[index] > change:
				change_up[index] -= 1
		for index in range(change_down.size()):
			if change_down[index] > change:
				change_down[index] -= 1

						

	# Changes references to rules
	for change in change_up:
		for i in range(new_pattern.size()):
			for j in range(new_pattern[i].size()):
				for k in range(4):
					
					if new_pattern[i][j][k] > change:
						new_pattern[i][j][k] += 1
						
		for index in range(change_up.size()):
			if change_up[index] > change:
				change_up[index] += 1


	
	for rule in range(new_pattern.size()):
		var roll = randfn(0, variation)

		if roll > 2:
			new_pattern[rule].append(generate_new_cell(new_pattern.size()))
		
		if roll < -2 and new_pattern[rule].size() > 0:
			new_pattern[rule].remove_at(range(new_pattern[rule].size()).pick_random())



	var rules = range(new_pattern.size())
	for i in range(new_pattern.size()):
			for j in range(new_pattern[i].size()):
				for k in range(4):
					
					var roll = randfn(0, variation)
					
					if roll > 1.64 and new_pattern[i][j][k] != -1:
						new_pattern[i][j][k] = -1
					elif roll > 1.64 and new_pattern[i][j][k] == -1:
						new_pattern[i][j][k] = rules.pick_random()
	

	MyTools.check_pattern(new_pattern)
	


	return new_pattern
