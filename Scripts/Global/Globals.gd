extends Node

## Provides a global reference to the main map and the root map.operator !=
## This reduces the need to pass the reference around and is only required to be set once, when simulation starts / loads
var mainMap : TileMap 
var rootMap : TileMap


enum Mask{
	TILE_MAP,
	PLANT,
	FOOD,
	CREATURE_MOUTH,
	CREATURE_BODY,
	CREATURE_SENSOR, 
}


const WALL_TILE = Vector2i(9,0)
