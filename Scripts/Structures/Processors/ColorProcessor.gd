class_name ColorProcessor extends Processor


@export var color : Color

## Defines how close tow color need to be to each other to be consider similar
@export var distance: int


func _init():
	masks = [Globals.Mask.FOOD, Globals.Mask.PLANT, Globals.Mask.CREATURE_BODY]


func process(data: Data) -> bool:
	if "color" in data:
		var opposite = data.get("color") as Color
		var dist = sqrt( pow(color.r - opposite.r, 2) + pow(color.g - opposite.g, 2) + pow(color.b - opposite.b, 2) )
		
		return dist < distance



	return false


func mutate():

	var mutated_sensor = ColorProcessor.new()

	mutated_sensor.color = Mutation.Color(color, 0.01)
	mutated_sensor.distance = Mutation.Integer(distance, 2)

	
	return mutated_sensor


func _to_string():
	return "ColorProcessor: " + str(color) + " with margin " + str(distance)


func _to_dict():
	return {
		"type": "ColorProcessor",
		"color": str(color),
		"distance": distance
	}


func get_color():
	return Color.DARK_MAGENTA

func get_processor_name():
	return "Color Sensor"

func get_description():

	var text = ""

	text += "Detecting color: " + str(color) + "\n"
	text += "Within Distance: " + str(distance) + "\n"

	return text
