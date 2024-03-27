class_name ColorProcessor extends Processor


@export var color : Color

## Defines how close tow color need to be to each other to be consider similar
@export var distance: int


func _init():
	masks = [Globals.Mask.FOOD, Globals.Mask.PLANT]


func process(data: Data) -> bool:
	if "color" in data:
		var opposite = data.get("color") as Color
		var dist = sqrt( pow(color.r - opposite.r, 2) + pow(color.g - opposite.g, 2) + pow(color.b - opposite.b, 2) )
		
		return dist < distance



	return false


func mutate(frequency : float, strenght : float ):

	var base_change = strenght * 10

	if randf() < frequency:
		distance = randi_range(distance - base_change, distance + base_change)

	


	pass