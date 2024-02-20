class_name SelfProcessor extends BasicProcessor



func _init():

    ## Used in init and in mutate, needs to be set to compatible values
    detectable_values = ["health, energy"]

    super._init()

    masks = []


## Processes data that are collected from sensor  
func process(data : Data) -> bool:	
    if data is CreatureData:
        return super.process(data)

    return false;


## Mutate handled in super 