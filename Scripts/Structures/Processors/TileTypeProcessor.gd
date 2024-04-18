class_name TileTypeProcessor extends Processor


@export var tileType : Globals.Tile


func _init():

	tileType = Globals.Tile.values().pick_random()

	if tileType == Globals.Tile.WALL:
		# Walls are not allowed to be processed by this processor
		masks = [Globals.Mask.TILE_MAP]


func process(data : Data):
	
	if data is TileTypeData:
		return tileType in data.tiles
	
	return false


## Mutate handled in super, there is nothing to change here.



func _to_string():
	return "TileTypeProcessor: " + Globals.Tile.keys()[tileType]

func _to_dict():
	return {
		"type": "TileTypeProcessor",
		"tileType": Globals.Tile.keys()[tileType]
	}
