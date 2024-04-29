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
func mutate():
	return self.duplicate()

func is_in_distance(data : Data):
	return data.distance > minDistance


## All these functions bellow server mostly for GUI purposes, but implementing them in your own processor they will assure correct displaying

func get_color():
	return Color.BLACK


func get_processor_name():
	return "Processor"
	
func get_description():
	return "This is abstract processor class and if you are seeing this you should implement this function in it's child"

func is_internal():
	return false
