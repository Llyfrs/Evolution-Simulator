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

	masks = [Globals.Mask.FOOD, Globals.Mask.PLANT, Globals.Mask.TILE_MAP]


	pass

func process(data : Data) -> bool:
	if value in data and is_in_distance(data):
		return upper_limit > data.get(value) and lower_limit < data.get(value)
	
	return false



## Should value also have a chance to mutate ? or should that be handled by changing sensors being deleted and created
func mutate(frequency: float, strength: float):
	var basic_change = 5

	## super.mutate() - maybe good for 

	if randf() < frequency:
		upper_limit += randi_range( floor(-basic_change * strength), ceil(basic_change * strength))

	if randf() < frequency:
		lower_limit += randi_range( floor(-basic_change * strength), ceil(basic_change * strength))


	upper_limit = maxi(0, upper_limit)
	lower_limit = maxi(0, lower_limit)

	if upper_limit < lower_limit:
		var tmp = upper_limit
		upper_limit = lower_limit
		lower_limit = tmp
