class_name SelfProcessor extends BasicProcessor



func _init():

	## Used in init and in mutate, needs to be set to compatible values
	detectable_values = ["health", "energy"]

	super._init()

	masks = []


## Processes data that are collected from sensor  
func process(data : Data) -> bool:	
	if data is SelfData:
		return upper_limit > data.get(value) and lower_limit < data.get(value)

	return false;


## Mutate handled in super 


func _to_dict() -> Dictionary:
	return {
		"type": "SelfProcessor",
		"upper_limit": upper_limit,
		"lower_limit": lower_limit,
		"value": value,
		"masks": masks
	}


func is_internal():
	return true


func get_color():

	if value == "energy":
		return Color.SEA_GREEN
	
	if value == "health":
		return Color.ORANGE_RED

	return Color.ANTIQUE_WHITE

func get_processor_name():
	return "Self Sensor"

func get_description():

	var text = ""

	text += "Detecting: " + value + "\n"
	text += "Between " + str(lower_limit) + " and " + str(upper_limit) + "\n"
	text += "This sensor detecting creatures values not outside information"

	return text
