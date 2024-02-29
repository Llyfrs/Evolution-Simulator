class_name Processor extends Resource



## Defines what collision layers the sensor should detect.  
@export var masks : Array

@export var minDistance : int


func _init():
	minDistance = randi_range(0,Globals.PROCESSOR_MIN_DISTANCE)

## Processes data that are collected from sensor  
func process(_data : Data) -> bool:	
	return false;


## Each Process is going to work with different type of values so it will require special mutation processes
func mutate(_frequency : float, _strenght : float ):
	pass



func is_in_distance(data : Data):
	return data.distance > minDistance
