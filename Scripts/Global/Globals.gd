extends Node
"""

This file is used for global variables used by multiple scripts and objects.
It also defines some constants for easy adjustment of some limits in the game that 
might need to be changed latter to ballance the simulations

"""



## Provides a global reference to the main map and the root map.operator !=
## This reduces the need to pass the reference around and is only required to be set once, when simulation starts / loads
var mainMap : TileMap 
var rootMap : TileMap


## Controls the minium creatures and plants there can be at the same time at any give time. If the value is bellow this it new ones will be spawned
var min_creatures : int = 0
var min_plants : int = 0


## Enum for tiles, it's used in all the parts of the program that deal with it, allowing for everything to stay consistent.
enum Tile{
	GRASS,
	STONE,
	WATER,
	SAND,
	WALL
}



## Converts string representation that was used when giving tiles custom data to the enum
func get_tile_type(cords : Vector2i) -> Array[Tile]:
	var data = mainMap.get_cell_tile_data(0,cords)
	if data == null:
		return []
		
	var types = data.get_custom_data("Type")

	var value : Array[Tile] = []
	for type in types:
		match type:

			"sand":
				value.append(Tile.SAND)

			"water":
				value.append(Tile.WATER)
			
			"grass":
				value.append(Tile.GRASS)
			
			"stone":
				value.append(Tile.STONE)

	
	return value
"""

CURSOR

All global variables surrounding the cursor and it's behavior

"""

## Enum for the different modes the cursor can be in, rest of the program can use this to define it's behavior
enum CursorMode {
	SELECT, ## Selects creatures and plants
	PAINT, ## Paints tiles
	PLANT, ## Places plants, either random or specific species
	CREATURE, ## Places creatures, either random or specific species
}


## Enum for the different tiles the cursor can paint, should be merged with Tile enum one day
enum PaintMode{
	GRASS,
	STONE,
	WATER,
	SAND,
	WALL
}


## Here we define the current cursor mode and paint mode
var cursor : CursorMode = CursorMode.SELECT
var paint_mode : PaintMode = PaintMode.GRASS


## If cursor is obscured it should not perform it's actions like placing creatures or plants, or painting tiles, this is used when interacting with UI
var cursor_obscured : bool = false


## The amount of energy tile gets when painted
var tile_energy : int = 100


## Currently selected creatures. (It can be more that one because the can be in the same spot on the map)
var selected : Array


## Corresponds to the set masks name in the editor, in it they start from 1 but enum starts from 0 so it needs to be set as. 
enum Mask{
	TILE_MAP=1,
	PLANT,
	FOOD,
	CREATURE_MOUTH,
	CREATURE_BODY,
	CREATURE_SENSOR, 
}




"""
General Constants to adjust default behavior of the program

(This should have been way bigger section controlling every static value in the program but I forgot about it mostly lol)

It still serves it's purpose but should be expanded over time if possible

""" 

## Defines the max minimum value in the processor _init when generating
const PROCESSOR_MIN_DISTANCE = 100

## Defines the max value used when generating upper and lower limits in BasicProcessor
const PROCESSOR_MAX_LIMIT = 100


## Constants of atlas coordinations in TileMaps
const WALL_TILE = Vector2i(9,0)

const WATER_TILE = Vector2(1,1)
const GRASS_TILE = Vector2(4,1)
const STONE_TILE = Vector2(7,1)
const SAND_TILE = Vector2(7,4)

## Having it here prevents circular dependencies 
var creature_scene = preload("res://Scenes/Creatures/creature.tscn")
var plant_scene = preload("res://Scenes/Plants/plant.tscn") 

var main_menu = preload("res://Scenes/MainMenu/MainMenu.tscn")

var SaveBox = preload("res://Scenes/GUI/SimulationSaveBox.tscn")
var simulation = preload("res://Scenes/Maps/main.tscn") as PackedScene

## Save manager put's it's self in to this variable to be used by different processes.
var save_manager 


"""
Handles Copying and saving creatures and plants
"""


## This will hold creatures and plants that the user want's to recreate
var copy = null

var saved_creatures : Array[NamedCreature] = []
var saved_plants : Array[NamedPlant] = []


"""
Handles IDs mostly just making sure there aren't duplicated values
"""

var used_IDs : Array = []
func get_ID() -> int:
	var id = randi()
	while used_IDs.has(id):
		id = randi()


	return id


