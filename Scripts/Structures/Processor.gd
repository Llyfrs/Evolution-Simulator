class_name Processor extends Resource



## Defines what collision layers the sensor should detect.  
@export var masks : Array



## Processes data that are collected from sensor  
func process(data : Data) -> bool:	
	return false;





## Each Process is going to work with different type of values so it will require special mutation processes
func mutate(frequency : float, strenght : float ):
	pass
