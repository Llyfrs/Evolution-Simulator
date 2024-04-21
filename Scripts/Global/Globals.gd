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

All global variables around a cursor

"""

enum CursorMode {
	SELECT,
	PAINT,
	PLANT,
	CREATURE,
}

enum PaintMode{
	GRASS,
	STONE,
	WATER,
	SAND,
	WALL
}


var cursor : CursorMode = CursorMode.SELECT

var paint_mode : PaintMode = PaintMode.GRASS

var cursor_obscured : bool = false

var tile_energy : int = 100


## Currently selected creatures. (It can be more that one because the can be in the same spot on the map)
var selected : Array


# Enums start from zero but masks start from 1 
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

(This should have been way higher section controlling every static value in the program but I forgot about it mostly lol )
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



## Save manager put's it's self in to this variable to be used by different processes.
var save_manager 




"""
Handles IDs mostly just making sure there aren't duplicated values
"""

var used_IDs : Array[int] = []
func get_ID() -> int:
	var id = randi()
	while used_IDs.has(id):
		id = randi()


	return id
