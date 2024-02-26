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


var selected : Array




enum Tile{
	GRASS,
	STONE,
	WATER,
	SAND
}



"""

CURSOR

All global variables around a cursor

"""

enum CursorMode {
	SELECT,
	PAINT
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
var creature_scene = preload("res://Scenes/Maps/creature.tscn")
var plant_scene = preload("res://Scenes/Plants/plant.tscn") 


