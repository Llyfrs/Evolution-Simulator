class_name TypeProcessor extends Processor

@export var type : int

static var types = [PlantData, CreatureData, SeedData, WallData]

func _init():
	type = range(types.size()).pick_random()
	masks = []


## Processes data that are collected from sensor  
func process(data : Data) -> bool:	
	
	if type == 0 and data is PlantData:
		return true
	
	if type == 1 and data is CreatureData:
		return true
	
	if type == 2 and data is SeedData:
		return true
		
	if type == 3 and data is WallData:
		return true
	
	return false

## Mutate handled in super 


func _to_string():
	return "TypeProcessor: " + str(type)

func _to_dict():
	return {"type": "TypeProcessor", "type_checked": get_type_string()}


func get_type_string():
	if type == 0:
		return "PlantData"
	if type == 1:
		return "CreatureData"
	if type == 2:
		return "SeedData"
	if type == 3:
		return "WallData"


func get_color():
	if type == 0:
		return Color.LAWN_GREEN
	if type == 1:
		return Color.INDIAN_RED
	if type == 2:
		return Color.LIME_GREEN
	if type == 3:
		return Color.DARK_GRAY


func get_processor_name():
	return "Type Sensor"

func get_description():

	var text = ""

	if type == 0:
		text = "This sensor detects plants."

	if type == 1:
		text = "This sensor detects creatures."

	if type == 2:
		text = "This sensor detects seeds."

	if type == 3:
		text = "This sensor detects walls."

	return text
