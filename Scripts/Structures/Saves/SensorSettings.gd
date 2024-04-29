class_name SensorSettings extends Resource

## This class holds all the information about a sensor, how it behaves and what and with what it interacts.
## The separation from Sensor.gd is needed for two reasons:
## 1. You can not save RayCast2D as a resource, and thus the data would be hard to load. Yes you could manually take them and put them in to a save file as I do in other places but that would not solve problem 2.
## 2. We need the sensors to be in the CreatureDNA so we can save it's history / generations, and for this reason it cannot be un-savable object as the entire DNA should be possible to save to the dist as resource, otherwise the code would be hard to maintain.   


@export var processor : Processor 
@export var receiver  : Creature.Influence 


## Type of weight to certain sensors, this allows some sensors to have priority or lead to more drastic outcomes
@export var influence : int


@export var range : float
@export var angle : float



static var processors = [BasicProcessor ,ColorProcessor, SelfProcessor, TileTypeProcessor, TypeProcessor]

func _init():

	processor = processors[randi() % processors.size()].new()
	receiver = Creature.Influence.values().pick_random()

	range = randi_range(20,300)
	angle = randf_range(0, 2 * PI)

	influence = randi_range(30,60)


func mutate():
	
	var mutated_sensor = SensorSettings.new()


	# Changing the processor and receiver will require for outside creation of new sensor 
	mutated_sensor.processor = processor.mutate()
	mutated_sensor.receiver = receiver

	mutated_sensor.range = Mutation.Float(range, 3)
	mutated_sensor.angle = Mutation.Float(angle,  0.043) # 0.043 is aobut 2.5 degrees 

	mutated_sensor.influence = Mutation.Integer(influence, 1)
	
	

	return mutated_sensor


func _to_string():
	return str(_to_dict())

func _to_dict():
	return {
		"processor" : processor._to_dict(),
		"receiver" : Creature.Influence.keys()[receiver],
		"influence" : influence,
		"range" : range,
		"angle" : angle
	}
