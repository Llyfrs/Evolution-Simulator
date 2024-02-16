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

## TODO: what type off sensor was this setting for
@export var type : int