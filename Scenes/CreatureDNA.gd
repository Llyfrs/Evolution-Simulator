class_name CreatureDNA extends Resource


# Similarly to the plants, creatures will have max energy and health capacities. 
# The allow for a more complex system where the creature has a growth phase. 
@export var energy : int
@export var health : int


## Determines damage dealt to other creatures and plants and also if the creature can eat seeds based on their durability
@export var bite_strength : int



@export var color : Color

## What sensors the creature is using
@export var sensors : Array[SensorSettings]


@export var influence_decay : Array

var processors = [ColorProcessor, BasicProcessor]



func _init():

    print_debug("CreatureDNA init")


    energy = randi_range(10,200)
    health = randi_range(10,200)

    bite_strength = randi_range(1,10)

    influence_decay.resize(Creature.Influence.size())
    
    for i in range(Creature.Influence.size()):
        influence_decay[i] = randi_range(0, 20)


    for i in range(0,randi_range(2,5)):
        var sensor = SensorSettings.new()

        ## The processor will be randomly generate in it's own _init function. 
        ## that way we don't have to worry about what processor was chosen.
        sensor.processor = processors[randi() % processors.size()].new()
        sensor.receiver = Creature.Influence.values().pick_random()

        sensor.range = randi_range(50,300)
        sensor.angle = randf_range(0, 2 * PI)

        sensor.influence = randi_range(1,20)

        sensors.append(sensor)
    


    pass