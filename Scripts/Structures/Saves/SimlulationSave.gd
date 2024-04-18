class_name SimulationSave extends Resource

## This Class represents a save for a entier simulation, including maps, and energy mannager settings._add_constant_central_force
## The idea is to save objects of this class with ResourceSaver and to use these saved resources as saves for entier simulation_precision





## All the active plants, seeds and creatures uses PlantSave, RootSave and CreatureSave
@export var active : Array[Save]


## Used for saving infromatin from EnergyManager
@export var tile_energy : Dictionary
@export var lost_energy : float



## The maps are saved in format key - Vector2i, value : TileSave
@export var rootMap : Dictionary
@export var mainMap : Dictionary


@export var max_creature_generation = 0
@export var max_plant_generation = 0

@export var recorded_dna: Array = []