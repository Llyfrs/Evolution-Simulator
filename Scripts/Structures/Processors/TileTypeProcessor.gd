class_name TileTypeProcessor extends Processor


@export var tileType : Globals.Tile


func _init():
	masks = []


func process(data : Data):
	
	if data is TileTypeData:
		return tileType in data.tiles
	
	return false
