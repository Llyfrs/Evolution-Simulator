class_name TileSave
extends Resource

## Wild the game doesn't have this format by default

@export var atlas_coords : Vector2i
@export var alternative : int
@export var source : int


## NOTE: Do not define _init func as it will be attempted to be used when ResourceLoader is called


## Loads tile data in to the object from map and coordinates for specific tile
## best used with `get_used_cells` function. Also returns self for convenience
func save(map: TileMap, cell: Vector2i, layer: int = 0):
	atlas_coords = map.get_cell_atlas_coords(layer,cell)
	alternative = map.get_cell_alternative_tile(layer, cell)
	source = map.get_cell_source_id(layer, cell)
	return self   



## Loads data from TileSave to your map
func load(map: TileMap, cell: Vector2i, layer: int = 0):
	map.set_cell(layer, cell, source, atlas_coords, alternative)
