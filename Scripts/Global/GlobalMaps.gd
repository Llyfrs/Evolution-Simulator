extends Node

## Provides a global reference to the main map and the root map.operator !=
## This reduces the need to pass the reference around and is only required to be set once, when simulation starts.

var mainMap : TileMap 
var rootMap : TileMap
