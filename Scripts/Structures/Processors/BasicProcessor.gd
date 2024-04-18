class_name BasicProcessor extends Processor

@export var upper_limit : int 
@export var lower_limit : int

@export var value : String

## Maybe needs to be moved to global or made more dynamic? 


var detectable_values = ["health", "energy", "durability"]


# TODO: implement initialization
func _init():

	var ar = 	[randi_range(0, Globals.PROCESSOR_MAX_LIMIT),  
				 randi_range(0, Globals.PROCESSOR_MAX_LIMIT)]

	upper_limit = ar.max()
	lower_limit = ar.min()

	value = detectable_values.pick_random()

	masks = [Globals.Mask.FOOD, Globals.Mask.PLANT, Globals.Mask.TILE_MAP, Globals.Mask.CREATURE_BODY]


	pass

func process(data : Data) -> bool:
	if value in data and is_in_distance(data) and !(data is SelfData):
		return upper_limit > data.get(value) and lower_limit < data.get(value)
	
	return false



## Should value also have a chance to mutate ? or should that be handled by changing sensors being deleted and created
func mutate():

	var mutated_processor = BasicProcessor.new()

	mutated_processor.upper_limit = Mutation.Integer(upper_limit, 2)
	mutated_processor.lower_limit = Mutation.Integer(lower_limit, 2)

	if mutated_processor.upper_limit < mutated_processor.lower_limit:
		var tmp = mutated_processor.upper_limit
		mutated_processor.upper_limit = mutated_processor.lower_limit
		mutated_processor.lower_limit = tmp

	return mutated_processor

func _to_string():
	return "BasicProcessor: " + str(lower_limit) + "<" +  value + "<" + str(upper_limit)

func _to_dict():
	return {"type": "BasicProcessor", "upper_limit": upper_limit, "lower_limit": lower_limit, "value": value}