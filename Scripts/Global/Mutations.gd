class_name Mutation


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
		Float(color.r, variation),
		Float(color.g, variation),
		Float(color.b, variation)
	)


static func PropertyVariations(variations : Dictionary):

	var global = variations.get("self", 0)
	var new_variations = {}

	for key in variations.keys(): 
		new_variations[key] = Float(variations[key], global)
		# print("Mutating: " + str(key) + " from " + str(variations[key]) + " to " + str(new_variations[key]))

	return new_variations


static func Pattern(pattern : Array[Array], variation : float):
	var new_pattern = []
	var change = {}

	for rule in range(pattern.size()):
		var roll = randfn(0, variation)


		if roll > 2:
			new_pattern.append([])
			change[rule] = 1


		if roll < -2: 
			return

		new_pattern.append(pattern[rule])
		



	return new_pattern